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
}

enum SectionType: Int, CaseIterable {
    case imageLabel
    case params
    case info
    case launches
}

struct Section {
    let type: SectionType
    let cells: [Cell]
}

class PageDetailViewController: UIViewController {
    
    let rockets = Bundle.main.decode([RocketModel].self, from: "rocket.json")
    
    var index: Int = 0
    var dataSource: UICollectionViewDiffableDataSource<SectionType, Cell>! = nil
    var collectionView: UICollectionView! = nil
    //    @IBOutlet var imageView: UIImageView!
    
    var images = ["img1", "img2", "img3", "img4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.imageView.image = UIImage(named: images[index])
        view.backgroundColor = .orange
        navigationItem.title = "Rocket"
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    static func getInstance(index: Int) -> PageDetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageDetailViewController") as! PageDetailViewController
        vc.index = index
        return vc
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .blue
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
                    Cell(title: "Высота", value: String(rocket.height.meters)),
                    Cell(title: "Диаметр", value: String(rocket.diameter.meters)),
                    Cell(title: "Масса", value: String(rocket.mass.kg)),
                    Cell(title: "Нагрузка", value: String(rocket.payloadWeights[0].kg))
                ]
            ),
            Section(
                type: .info,
                cells: [
                    Cell(title: "Первый запуск", value: rocket.firstFlight),
                    Cell(title: "Страна", value: rocket.country),
                    Cell(title: "Стоимость запуска", value: rocket.launchCost),
                    Cell(title: "Количество двигателей", value: String(rocket.firstStage.engines)),
                    Cell(title: "Количество топлива", value: String(rocket.firstStage.fuelAmountTons)),
                    Cell(title: "Время сгорания", value: String(rocket.firstStage.burnTimeSec ?? 0)),
                    Cell(title: "Количество двигателей", value: String(rocket.secondStage.engines)),
                    Cell(title: "Количество топлива", value: String(rocket.secondStage.fuelAmountTons)),
                    Cell(title: "Время сгорания", value: String(rocket.secondStage.burnTimeSec ?? 0))
                ]
            ),
            Section(
                type: .launches,
                cells: [
                    Cell(title: "Запуски", value: rocket.id)
                ])
        ]
    }

    func createDataSource() {
        dataSource = .init(collectionView: collectionView) { (collectionView, indexPath, model) in
            let section = SectionType(rawValue: indexPath.section) ?? .info
            switch section {
            case .imageLabel:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as? ImageCollectionViewCell
                cell?.configure(with: model)
                return cell
            case .params:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.reuseId, for: indexPath) as? HorizontalCollectionViewCell
                cell?.configure(with: model)
                return cell
            case .info:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseId, for: indexPath) as? VerticalCollectionViewCell
                cell?.configure(with: model)
                return cell
            case .launches:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseId, for: indexPath) as? ButtonCollectionViewCell
                return cell
            }
        }
    }

    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Cell>()
        let rocket = rockets?.first! // в каждом pageDetailViewController будет своя рокета
        let sections = makeSections(from: rocket!)

        sections.forEach { section in
            snapshot.appendSections([section.type])
            snapshot.appendItems(section.cells, toSection: section.type)
        }

        dataSource?.apply(snapshot)
    }
    
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
        case .info:
            return infoSection()
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
        group.contentInsets = .init(top: 10.0, leading: 0.1, bottom: 10.0, trailing: 0.1)
        group.interItemSpacing = .fixed(1.0)
        
        let rootGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/3.2),
                                                   heightDimension: .fractionalHeight(1.0/7.0))
        let rootGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rootGroupSize, subitems: [group])
        let section = NSCollectionLayoutSection(group: rootGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    
    private func infoSection() -> NSCollectionLayoutSection {
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 5, trailing: 0)
        // section.supplementariesFollowContentInsets = true

        return section
    }
    
    private func launchesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let rootGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.08))
        let rootGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rootGroupSize, subitems: [group])
        let section = NSCollectionLayoutSection(group: rootGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        return section
    }
}










//        let itemSize = NSCollectionLayoutSize (
//            widthDimension: .fractionalWidth(0.2),
//            heightDimension: .fractionalHeight(1.0)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize (
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .absolute(50)
//        )
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        group.interItemSpacing = .fixed(5)
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        section.interGroupSpacing = 5
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 200
//        layout.configuration = config
//
//        return layout

















//    func setupCollectionView() {
//        collectionView.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: HorizontalCollectionViewCell.reuseId)
//        collectionView.register(VerticalCollectionViewCell.self, forCellWithReuseIdentifier: VerticalCollectionViewCell.reuseId)
//    }

//    func createDataSource() {
//        dataSource = .init(collectionView: collectionView) { (collectionView, indexPath, model) in
//            let section = SectionType(rawValue: indexPath.section) ?? .info
//            switch section {
//            case .parameters:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.reuseId, for: indexPath) as? HorizontalCollectionViewCell
//                let model = self.paramsArray[indexPath.row]
//                cell?.configure(with: model)
//                return cell
//            case .info:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseId, for: indexPath) as? VerticalCollectionViewCell
//                let model = self.infoArray[indexPath.row]
//                cell?.configure(with: model)
//                return cell
//            }
//        }
//    }
//
//    func reloadData() {
//        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Cell>()
//        let rocket = rockets?.first // в каждом pageDetailViewController будет своя рокета
//        let sections = makeSections(from: rocket!)
//
//        sections.forEach { section in
//            snapshot.appendSections([section.type])
//            snapshot.appendItems(section.cells, toSection: section.type)
//        }
//
//        dataSource?.apply(snapshot)
//    }
//
//
//
//    // MARK: - Setup Layout
//
//    func createCompositionalLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            let section = self.dataSource?.snapshot().sectionIdentifiers[sectionIndex]
//
//            switch section {
//            case .parameters:
//                return self.createDetailParametersSection()
//            default:
//                return self.createMainInfoSection()
//            }
//        }
//
//        return layout
//    }
//
//    func createDetailParametersSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                              heightDimension: .fractionalHeight(1))
//        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)
//
//
//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(104),
//                                                     heightDimension: .estimated(88))
//        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
//
//        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        layoutSection.orthogonalScrollingBehavior = .continuous
//        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 12, bottom: 0, trailing: 12)
//
//        return layoutSection
//    }
//
//    func createMainInfoSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .estimated(1))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 20, bottom: 0, trailing: 20)
//        return section
//    }
//}
//
//
//extension PageDetailViewController: UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//
//        cell.backgroundColor = UIColor.systemPink
//
//        return cell
//    }
//}


