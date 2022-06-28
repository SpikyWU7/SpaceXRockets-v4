//
//  PageDetailViewController.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 21.06.2022.
//

import UIKit

struct Cell: Hashable {
    let title: String
    let value: String
}

enum SectionType: Int {
    case image
    case parameters
    case info
}

struct Section {
    let type: SectionType
    let cells: [Cell]
}
class PageDetailViewController: UIViewController {

    var dataSource: UICollectionViewDiffableDataSource<SectionType, Cell>?

    let rockets = Bundle.main.decode([RocketModel].self, from: "rocket.json")
    var rocketNameArray: [Cell] = []
    let infoArray: [RocketMainInfo] = []

    var index: Int = 0

    @IBOutlet var collectionView: UICollectionView!
    //    @IBOutlet var imageView: UIImageView!

    var images = ["img1", "img2", "img3", "img4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.imageView.image = UIImage(named: images[index])
        view.backgroundColor = .orange
        setupCollectionView()
        createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        reloadData()
    }

    static func getInstance(index: Int) -> PageDetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageDetailViewController") as! PageDetailViewController
        vc.index = index
        return vc
    }

    func setupCollectionView() {
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId)
        collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: LabelCollectionViewCell.reuseId)
        collectionView.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: HorizontalCollectionViewCell.reuseId)
        collectionView.register(VerticalCollectionViewCell.self, forCellWithReuseIdentifier: VerticalCollectionViewCell.reuseId)
        collectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: ButtonCollectionViewCell.reuseId)
    }

    var sections: [Section] = []

    func makeSections(from rocket: RocketModel) -> [Section] {
        self.sections = [
            Section(type: .image, cells: [
                    Cell(title: "Имя", value: rocket.name)
            ])
//            Section(
//                type: .info,
//                cells: [
//                    Cell(title: "Высота", value: String(rocket.height.meters)),
//                    Cell(title: "Диаметр", value: String(rocket.diameter.meters))
//                    Cell(title: "Что угодно", value: String(rocket.diameter.meters))
//                ]
//            )
//            Section(
//                type: .parameters,
//                cells: [
//                    Cell(title: "Стоимость запуска", value: String(rocket.costPerLaunch)),
//                    Cell(title: "Страна", value: rocket.country)
//                    // и тд
//                ])
        ]
        return sections
    }

    func createDataSource() {
        dataSource = .init(collectionView: collectionView) { (collectionView, indexPath, model) in
            let section = SectionType(rawValue: indexPath.section) ?? .info
            let model = self.sections
            switch section {
            case .image: //(let image)
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
                cell.rocketName?.text = model[0].cells[0].value
//                cell.rocketImage.image = model[0].cells[0].value.randomElement()
                return cell
            case .info:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseId, for: indexPath) as? VerticalCollectionViewCell
                cell?.leftLabel.text = model[1].cells[0].value
                return cell
            case .parameters:
                return nil
            }

        }
    }


    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Cell>()
        let rocket = rockets?.first! // в каждом pageDetailViewController будет своя рaкета
        let sections = makeSections(from: rocket!)

        sections.forEach { section in
            snapshot.appendSections([section.type])
            snapshot.appendItems(section.cells, toSection: section.type)
        }

        dataSource?.apply(snapshot)
    }















    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = SectionType(rawValue: sectionIndex) else { return nil }
            // SectionType(rawValue: indexPath.section)
            switch section {
            case .image:
                return self.firstSection()
            case .parameters:
                return self.secondSection()
            case .info:
                return self.thirdSection()
            }
        }
        return layout
    }

    func firstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2),
                                              heightDimension: .fractionalHeight(2))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)


        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(104),
                                                     heightDimension: .estimated(88))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 12, bottom: 0, trailing: 12)

        return layoutSection
    }

    func secondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 20, bottom: 0, trailing: 20)
        return section
    }

    func thirdSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)


        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(104),
                                                     heightDimension: .estimated(88))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 12, bottom: 0, trailing: 12)

        return layoutSection
    }

    func fourthSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 20, bottom: 0, trailing: 20)
        return section
    }

    func fifthSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)


        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(104),
                                                     heightDimension: .estimated(88))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 12, bottom: 0, trailing: 12)

        return layoutSection
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


