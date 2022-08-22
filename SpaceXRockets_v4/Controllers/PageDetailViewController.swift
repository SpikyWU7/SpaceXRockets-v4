import UIKit

final class PageDetailViewController: UIViewController, CallLaunchesVCProtocol, CallSettingsVCProtocol {

    private let networkAPI = NetworkAPI.shared
    private var rockets: [RocketModel] = []
    private var index: Int = 0
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, Cell>! = nil
    private var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        createDataSource()
        reload()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reload),
            name: Notification.Name("reloadData"),
            object: nil
        )
    }

    @objc
    private func reload() {
        networkAPI.getRockets(dataType: [RocketModel].self) { data in
            self.rockets = data
            self.reloadData()
        }
    }

    static func getInstance(index: Int) -> PageDetailViewController {
        guard let vcInt = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: "PageDetailViewController"
        ) as? PageDetailViewController else {
            return PageDetailViewController()
        }
        vcInt.index = index
        return vcInt
    }
    // swiftlint:disable force_cast
    func presentLaunchesViewController() {
        let viewController = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: "LaunchesViewController"
        ) as! LaunchesViewController
        viewController.rocketID = rockets[self.index].id
        viewController.rocketName = rockets[self.index].name
        self.present(viewController, animated: true)
    }

    func presentSettingsViewController() {
        let viewController = UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: "SettingsViewController"
        ) as! SettingsViewController
        self.present(viewController, animated: true)
    }
    // swiftlint:enable force_cast

// MARK: - setupCollectionView()

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        let headerNib = UINib(nibName: StagesHeaderView.reuseId, bundle: nil)
        collectionView.register(
            headerNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StagesHeaderView.reuseId
        )
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

    private func makeSections(from rocket: RocketModel) -> [Section] {
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
                    UserDefaults.standard.string(forKey: Params.height.rawValue) == Params.m.rawValue
                    ? Cell(title: "Высота, ft", value: String(rocket.height.feet))
                    : Cell(title: "Высота, m", value: String(rocket.height.meters)),
                    UserDefaults.standard.string(forKey: Params.diameter.rawValue) == Params.m.rawValue
                    ? Cell(title: "Диаметр, ft", value: String(rocket.diameter.feet))
                    : Cell(title: "Диаметр, m", value: String(rocket.diameter.meters)),
                    UserDefaults.standard.string(forKey: Params.mass.rawValue) == Params.kg.rawValue
                    ? Cell(title: "Масса, lb", value: String(rocket.mass.lbInt))
                    : Cell(title: "Масса, kg", value: String(rocket.mass.kgInt)),
                    UserDefaults.standard.string(forKey: Params.payweight.rawValue) == Params.kg.rawValue
                    ? Cell(title: "Нагрузка, lb", value: String(rocket.payloadWeights[0].lbInt))
                    : Cell(title: "Нагрузка, kg", value: String(rocket.payloadWeights[0].kgInt))
                ]
            ),
            Section(
                type: .mainSection,
                cells: [
                    Cell(title: "Первый запуск", value: rocket.firstLaunch),
                    Cell(title: "Страна", value: rocket.country),
                    Cell(title: "Стоимость запуска", value: rocket.launchCost)
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
                ]
            )
        ]
    }

// MARK: - createDataSource

    private func createDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, model in
            let section = SectionType(rawValue: indexPath.section) ?? .mainSection
            switch section {
            case .imageLabel:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ImageCollectionViewCell.reuseId,
                    for: indexPath
                ) as? ImageCollectionViewCell else {
                    return UICollectionViewCell()
                }
                self.networkAPI.image(post: self.rockets[self.index]) { data, _ in
                    DispatchQueue.main.async {
                        let img = self.networkAPI.image(data: data)
                        cell.image = img
                    }
                }
                cell.configure(with: model)
                cell.cellDelegate = self
                return cell
            case .params:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HorizontalCollectionViewCell.reuseId,
                    for: indexPath
                ) as? HorizontalCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: model)
                return cell
            case .mainSection:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: VerticalCollectionViewCell.reuseId,
                    for: indexPath
                ) as? VerticalCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: model)
                return cell
            case .firstStage:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: VerticalCollectionViewCell.reuseId,
                    for: indexPath
                ) as? VerticalCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: model)
                return cell
            case .secondStage:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: VerticalCollectionViewCell.reuseId,
                    for: indexPath
                ) as? VerticalCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: model)
                return cell
            case .launches:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ButtonCollectionViewCell.reuseId,
                    for: indexPath
                ) as? ButtonCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.cellDelegate = self
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            self.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
    }

    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StagesHeaderView.reuseId,
            for: indexPath
        ) as? StagesHeaderView else {
            return UICollectionReusableView()
        }
        if indexPath.section == 3 {
            header.configure(with: "ПЕРВАЯ СТУПЕНЬ")
        } else {
            header.configure(with: "ВТОРАЯ СТУПЕНЬ")
        }
        return header
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, Cell>()
        let rocket = rockets[index]
        let sections = makeSections(from: rocket)
        sections.forEach { section in
            snapshot.appendSections([section.type])
            snapshot.appendItems(section.cells, toSection: section.type)
        }
        dataSource?.apply(snapshot)
    }
}
