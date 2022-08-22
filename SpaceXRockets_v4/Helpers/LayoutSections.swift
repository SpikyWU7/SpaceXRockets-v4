import Foundation
import UIKit

struct Cell: Hashable {
    let id = UUID()
    let title: String
    let value: String
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

extension PageDetailViewController {

    func createLayout() -> UICollectionViewLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { sectionIndex, layoutEnvironment
            -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionType(rawValue: sectionIndex) else {
                return nil
            }
            let section = self.layoutSection(section: sectionKind, layoutEnvironment: layoutEnvironment)
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }

    private func layoutSection(
        section: SectionType,
        layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
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
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(420)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: -0.12, leading: 0.0, bottom: 0.0, trailing: 0.0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }

    private func paramsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 1.0, leading: 5.0, bottom: 1.0, trailing: 5.0)

        let rootGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3.5),
            heightDimension: .fractionalHeight(1.0 / 7.5)
        )
        let rootGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rootGroupSize, subitems: [group])
        let section = NSCollectionLayoutSection(group: rootGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 5, bottom: 0, trailing: 5)
        return section
    }

    private func mainSection() -> NSCollectionLayoutSection {
        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let trailingGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1.0)
        )
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: trailingGroupSize,
            subitem: trailingItem,
            count: 9
        )
        let containerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.6)
        )
        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: containerGroupSize,
            subitems: [trailingGroup]
        )
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 5, bottom: 5, trailing: 5)
        return section
    }

    private func firstStage() -> NSCollectionLayoutSection {
        let trailingItem = NSCollectionLayoutItem(
            layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
        )
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let trailingGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1.0)
        )
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: trailingGroupSize,
            subitem: trailingItem,
            count: 9
        )
        let containerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.6)
        )
        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: containerGroupSize,
            subitems: [trailingGroup]
        )
        let section = NSCollectionLayoutSection(group: containerGroup)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: -10, leading: 5, bottom: 5, trailing: 5)
        return section
    }

    private func secondStage() -> NSCollectionLayoutSection {
        let trailingItem = NSCollectionLayoutItem(
            layoutSize:
                NSCollectionLayoutSize(
                    widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
        )
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let trailingGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1.0)
        )
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: trailingGroupSize,
            subitem: trailingItem,
            count: 9
        )
        let containerGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.6)
        )
        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: containerGroupSize,
            subitems: [trailingGroup]
        )
        let section = NSCollectionLayoutSection(group: containerGroup)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(70)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: -10, leading: 5, bottom: 5, trailing: 5)
        return section
    }

    private func launchesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0 / 8.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let rootGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0 / 8.0)
        )
        let rootGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rootGroupSize, subitems: [group])
        let section = NSCollectionLayoutSection(group: rootGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        return section
    }
}
