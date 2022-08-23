import Foundation
import UIKit

final class LaunchesViewController: UIViewController {

    @IBOutlet private var launchesTable: UITableView!
    @IBOutlet private var navItem: UINavigationBar!
    private var launchArray: [LaunchDates] = []
    private let networkAPI = NetworkAPI()
    var rocketID: String?
    var rocketName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.topItem?.title = rocketName
        launchesTable.dataSource = self
        launchesTable.register(
            UINib(
                nibName: RocketCell.reuseId,
                bundle: nil
            ),
            forCellReuseIdentifier: RocketCell.reuseId
        )
        networkAPI.getLaunches { [self] result in
            switch result {
            case .success(let launches):
                for element in launches {
                    if element.rocket == rocketID && rocketID != nil {
                        self.launchArray.append(element)
                    }
                }
                self.launchesTable.reloadData()
                self.launchArray.sort(by: { $0.dateUtc > $1.dateUtc })
            case .failure:
                print("Error getLaunches🚀")
            }
        }
    }

    @IBAction private func backButtonPressed() {
        self.dismiss(animated: true)
    }
}

// MARK: - DataSource

extension LaunchesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if launchArray.count > 1 {
            self.launchesTable.restore()
        } else {
            self.launchesTable.setEmptyMessage("На данный момент запусков не производилось")
        }
        return launchArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = launchesTable.dequeueReusableCell(withIdentifier: "RocketCell") as? RocketCell else {
            return UITableViewCell()
        }
        cell.initCell(with: launchArray[indexPath.row])
        cell.rocketCellDate.text = String.strToDate(
            string: launchArray[indexPath.row].dateUtc,
            fromDate: "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        )
        if launchArray[indexPath.row].success != nil {
            if launchArray[indexPath.row].success == true {
                cell.rocketImage.image = UIImage(named: "rocketTrue")
            } else {
                cell.rocketImage.image = UIImage(named: "rocketFalse")
            }
        } else {
            cell.rocketImage.image = UIImage(named: "unknown")
        }
        return cell
    }
}
