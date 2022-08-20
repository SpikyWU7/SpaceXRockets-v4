//
//  PageDetailViewController.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 21.06.2022.
//

import UIKit

struct Cell: Hashable {
    let id = UUID()
    let title: String
    let value: String
    //    let units: String
}

enum SectionType: Int, CaseIterable {
    case imageLabel
    case params
    case mainSection
    case firstStage
    case secondStage
    case launches
}

struct Section {
    let type: SectionType
    let cells: [Cell]
}

class PageDetailViewController: UIViewController, CallLaunchesVCProtocol, CallSettingsVCProtocol {

    private let format = Format()
    let networkAPI = NetworkAPI.shared
    var rockets: [RocketModel] = []
    var index: Int = 0
    var dataSource: UICollectionViewDiffableDataSource<SectionType, Cell>! = nil
    var collectionView: UICollectionView! = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        createDataSource()
        reload()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("reloadData"), object: nil)
    }

    @objc func reload() {
        networkAPI.getRockets(dataType: [RocketModel].self) { data in
            self.rockets = data
            self.reloadData()
        }
    }
    
    static func getInstance(index: Int) -> PageDetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageDetailViewController") as! PageDetailViewController
        vc.index = index
        return vc
    }

    func presentLaunchesViewController() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LaunchesViewController") as! LaunchesViewController
        viewController.rocketID = rockets[self.index].id
        viewController.rocketName = rockets[self.index].name
        self.present(viewController, animated: true, completion: nil)
    }

    func presentSettingsViewController() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.present(viewController, animated: true, completion: nil)
    }
    

    //MARK: - setupCollectionView

    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        let headerNib = UINib(nibName: StagesHeaderView.reuseId, bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StagesHeaderView.reuseId)
        let nib1 = UINib(nibName: ImageCollectionViewCell.reuseId, bundle: nil)
        collectionView.register(nib1, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId)
        let nib2 = UINib(nibName: VerticalCollectionViewCell.reuseId, bundle: nil)
        collectionView.register(nib2, forCellWithReuseIdentifier: VerticalCollectionViewCell.reuseId)
        let nib3 = UINib(nibName: HorizontalCollectionViewCell.reuseId, bundle: nil)
        collectionView.register(nib3, forCellWithReuseIdentifier: HorizontalCollectionViewCell.reuseId)
        let nib4 = UINib(nibName: ButtonCollectionViewCell.reuseId, bundle: nil)
        collectionView.register(nib4, forCellWithReuseIdentifier: ButtonCollectionViewCell.reuseId)
        view.addSubview(collectionView)
    }
    
    func makeSections(from rocket: RocketModel) -> [Section] {
        [
            Section(
                type: .imageLabel,
                cells: [
                    Cell(title: "Image", value: rocket.name)
                ]
            ),
            Section(
                type: .params,
                cells: [
                    UserDefaults.standard.string(forKey: K.height) == K.m
                    ? Cell(title: "Высота, ft", value: String(rocket.height.feet))
                    : Cell(title: "Высота, m", value: String(rocket.height.meters)),
                    UserDefaults.standard.string(forKey: K.diameter) == K.m
                    ? Cell(title: "Диаметр, ft", value: String(rocket.diameter.feet))
                    : Cell(title: "Диаметр, m", value: String(rocket.diameter.meters)),
                    UserDefaults.standard.string(forKey: K.mass) == K.kg
                    ? Cell(title: "Масса, lb", value: String(rocket.mass.lbInt))
                    : Cell(title: "Масса, kg", value: String(rocket.mass.kgInt)),
                    UserDefaults.standard.string(forKey: K.payweight) == K.kg
                    ? Cell(title: "Нагрузка, lb", value: String(rocket.payloadWeights[0].lbInt))
                    : Cell(title: "Нагрузка, kg", value: String(rocket.payloadWeights[0].kgInt))
                ]
            ),
            Section(
                type: .mainSection,
                cells: [
                    Cell(title: "Первый запуск", value: rocket.firstFlight),
                    Cell(title: "Страна", value: rocket.country),
                    Cell(title: "Стоимость запуска", value: rocket.launchCost),
                ]
            ),
            Section(
                type: .firstStage,
                cells: [
                    Cell(title: "Количество двигателей", value: String(rocket.firstStage.engines)),
                    Cell(title: "Количество топлива", value: "\(String(rocket.firstStage.fuelAmountTons)) ton"),
                    Cell(title: "Время сгорания", value: "\(rocket.firstStage.burnTimeSec ?? 0) sec")
                ]
            ),
            Section(
                type: .secondStage,
                cells:
                    [
                        Cell(title: "Количество двигателей", value: String(rocket.secondStage.engines)),
                        Cell(title: "Количество топлива", value: "\(rocket.secondStage.fuelAmountTons) ton"),
                        Cell(title: "Время сгорания", value: "\(rocket.secondStage.burnTimeSec ?? 0) sec")
                    ]
            ),
            Section(
                type: .launches,
                cells: [
                    Cell(title: "Запуски", value: rocket.id)
                ])
        ]
    }

    //MARK: - createDataSource

    func createDataSource() {
        dataSource = .init(collectionView: collectionView) { (collectionView, indexPath, model) in
            let section = SectionType(rawValue: indexPath.section) ?? .mainSection
            switch section {
            case .imageLabel:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as? ImageCollectionViewCell
                func image(data: Data?) -> UIImage? {
                    if let data = data {
                        return UIImage(data: data)
                    }
                    return UIImage(systemName: "img1")
                }
                self.networkAPI.image(post: self.rockets[self.index]) { data, error  in
                    let img = image(data: data)
                    DispatchQueue.main.async {
                        cell?.image = img
                    }
                }
                cell?.configure(with: model)
                cell?.cellDelegate = self
                return cell
            case .params:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.reuseId, for: indexPath) as? HorizontalCollectionViewCell
                cell?.configure(with: model)
                return cell
            case .mainSection:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseId, for: indexPath) as? VerticalCollectionViewCell
                cell?.configure(with: model)
                return cell
            case .firstStage:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseId, for: indexPath) as? VerticalCollectionViewCell
                cell?.configure(with: model)
                return cell
            case .secondStage:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseId, for: indexPath) as? VerticalCollectionViewCell
                cell?.configure(with: model)
                return cell
            case .launches:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseId, for: indexPath) as? ButtonCollectionViewCell
                cell?.cellDelegate = self
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            return self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
    }

    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StagesHeaderView.reuseId, for: indexPath) as! StagesHeaderView
        if indexPath.section == 3 {
            header.configure(with: "ПЕРВАЯ СТУПЕНЬ")
        } else {
            header.configure(with: "ВТОРАЯ СТУПЕНЬ")
        }
        return header
    }

    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Cell>()
        let rocket = rockets[index] // в каждом pageDetailViewController будет своя рокета
        let sections = makeSections(from: rocket)
        sections.forEach { section in
            snapshot.appendSections([section.type])
            snapshot.appendItems(section.cells, toSection: section.type)
        }
        dataSource?.apply(snapshot)
    }
}


//MARK: - createLayout
extension PageDetailViewController {

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionType(rawValue: sectionIndex) else { return nil }
            let section = self.layoutSection(section: sectionKind, layoutEnvironment: layoutEnvironment)
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    private func layoutSection(section: SectionType, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch section {
        case .imageLabel:
            return imageLabelSection()
        case .params:
            return paramsSection()
        case .mainSection:
            return mainSection()
        case .firstStage:
            return firstStage()
        case .secondStage:
            return secondStage()
        case.launches:
            return launchesSection()
        }
    }
    private func imageLabelSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(420))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: -0.12, leading: 0.0, bottom: 0.0, trailing: 0.0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func paramsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 1.0, leading: 5.0, bottom: 1.0, trailing: 5.0)
        
        let rootGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/3.5),
                                                   heightDimension: .fractionalHeight(1.0/7.5))
        let rootGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rootGroupSize, subitems: [group])
        let section = NSCollectionLayoutSection(group: rootGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 5, bottom: 0, trailing: 5)
        return section
    }
    
    private func mainSection() -> NSCollectionLayoutSection {
        let trailingItem =  NSCollectionLayoutItem(layoutSize:
                                                    NSCollectionLayoutSize(
                                                        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(1.0)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))

        let trailingGroup =  NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize, subitem: trailingItem, count: 9)

        let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalHeight(0.6))

        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [trailingGroup])

        let section = NSCollectionLayoutSection(group: containerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 5, bottom: 5, trailing: 5)
        return section
    }

    private func firstStage() -> NSCollectionLayoutSection {
        let trailingItem =  NSCollectionLayoutItem(layoutSize:
                                                    NSCollectionLayoutSize(
                                                        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(1.0)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))

        let trailingGroup =  NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize, subitem: trailingItem, count: 9)

        let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalHeight(0.6))

        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [trailingGroup])

        let section = NSCollectionLayoutSection(group: containerGroup)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 0, trailing: 0)

        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: -10, leading: 5, bottom: 5, trailing: 5)
        return section
    }

    private func secondStage() -> NSCollectionLayoutSection {
        let trailingItem =  NSCollectionLayoutItem(layoutSize:
                                                    NSCollectionLayoutSize(
                                                        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(1.0)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))

        let trailingGroup =  NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize, subitem: trailingItem, count: 9)

        let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalHeight(0.6))

        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [trailingGroup])

        let section = NSCollectionLayoutSection(group: containerGroup)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 0, trailing: 0)

        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: -10, leading: 5, bottom: 5, trailing: 5)
        // section.supplementariesFollowContentInsets = true
        return section
    }
    
    private func launchesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0/8.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let rootGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0/8.0))
        let rootGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rootGroupSize, subitems: [group])
        let section = NSCollectionLayoutSection(group: rootGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        return section
    }
}
