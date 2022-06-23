//
//  PageDetailViewController.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 21.06.2022.
//

import UIKit

class PageDetailViewController: UIViewController {

    enum Section {
        case parameters
        case info
//        case parameters(RocketDetailParameters)
//        case info(RocketMainInfo)
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, RocketModel>?

    let sections = Bundle.main.decode([RocketModel].self, from: "rocket.json")

    var index: Int = 0

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var imageView: UIImageView!

    var images = ["img1", "img2", "img3", "img4"]


    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: images[index])
        view.backgroundColor = .orange
        
    }

   static func getInstance(index: Int) -> PageDetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageDetailViewController") as! PageDetailViewController
        vc.index = index
        return vc
    }

    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, RocketModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, rocket) -> UICollectionViewCell? in
            switch self.sections {
            case .parameters:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.reuseId, for: indexPath) as? HorizontalCollectionViewCell
                cell?.configure(with: rocket)
                return cell
            case .info:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.reuseId, for: indexPath) as? VerticalCollectionViewCell
                cell?.configure(with: rocket)
                return cell
            }
        })
    }

    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RocketModel>()
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource?.apply(snapshot)
    }

    // MARK: - Setup Layout

    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]

            switch section.type {
            case "activeChats":
                return self.createDetailParametersSection()
            default:
                return self.createMainInfoSection()
            }
        }

        return layout
    }

    func createDetailParametersSection() -> NSCollectionLayoutSection {
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

    func createMainInfoSection() -> NSCollectionLayoutSection {
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
}












