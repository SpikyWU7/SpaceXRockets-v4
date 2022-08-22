//
//  LaunchesViewController.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 13.07.2022.
//

import Foundation
import UIKit

class LaunchesViewController: UIViewController {

    @IBOutlet private var launchesTable: UITableView!
    @IBOutlet var navItem: UINavigationBar!
    private var newArray: [LaunchDates] = []
    private let networkAPI = NetworkAPI()
    var dataArray = ["AAA", "BBB", "CCC"]
    var rocketID: String?
    var rocketName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.topItem?.title = rocketName
        launchesTable.dataSource = self
        launchesTable.register(UINib(nibName: RocketCell.reuseId, bundle: nil), forCellReuseIdentifier: RocketCell.reuseId)
        networkAPI.getLaunches { [self] (result) in
            switch result {
            case .success(let launches):
                for element in launches {
                    if element.rocket == rocketID! && rocketID != nil {
                        self.newArray.append(element)
                    }
                }
                self.launchesTable.reloadData()
                self.newArray.sort(by: { $0.dateUtc > $1.dateUtc })
            case .failure(_):
                print("Error")
            }
        }
    }

    @IBAction private func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARParams: - UITableViewDataSource

extension LaunchesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newArray.count != 0 {
            self.launchesTable.restore()
        } else {
            self.launchesTable.setEmptyMessage("На данный момент запусков не производилось")
        }
        return newArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = launchesTable.dequeueReusableCell(withIdentifier: "RocketCell") as? RocketCell else { return UITableViewCell() }
        cell.initCell(with: newArray[indexPath.row])
//        cell.backgroundColor = .black
//        cell.selectionStyle = .none
        let formatGet = DateFormatter()
        formatGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"

        let formatSet = DateFormatter()
        formatSet.dateFormat = "d MMMM, yyyy"

        guard let date = formatGet.date(from: newArray[indexPath.row].dateUtc) else { return UITableViewCell() }
        cell.rocketCellDate.text = formatSet.string(from: date)
        if newArray[indexPath.row].success != nil {
            if newArray[indexPath.row].success! {
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

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
