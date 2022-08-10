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

    private var newArray: [LaunchDates] = []
    private let networkAPI = NetworkAPI()
    var dataArray = ["AAA", "BBB", "CCC"]
    var rocketID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        launchesTable.dataSource = self
        launchesTable.backgroundColor = .blue
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
            case .failure(_):
                print("Error")
            }
        }
    }

    @IBAction private func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension LaunchesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newArray.count == 0 {
            self.launchesTable.setEmptyMessage("На данный момент запусков не производилось")
        } else {
            self.launchesTable.restore()
        }
        return newArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if let cell = launchesTable.dequeueReusableCell(withIdentifier: "RocketCell", for: indexPath) as? RocketCell {
        //            cell.setData(text: newArray[indexPath.row].name ?? "no data")
        //            return cell
        //        }

        guard let cell = launchesTable.dequeueReusableCell(withIdentifier: "RocketCell") as? RocketCell else { return UITableViewCell() }

        cell.backgroundColor = .black
        cell.selectionStyle = .none

        guard let name = newArray[indexPath.row].name else { return UITableViewCell() }
        cell.rocketCellLabel.text = name

        cell.rocketCellDate.text = newArray[indexPath.row].dateUtc

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









    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return newArray.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = launchesTable.dequeueReusableCell(withIdentifier: "RocketCell") as! RocketCell
    //
    //        cell.backgroundColor = .black
    //        cell.selectionStyle = .none
    //
    //        if let name = newArray[indexPath.row].name {
    //            cell.rocketCellLabel.text = name
    //        }
    //
    //        cell.rocketCellDate.text = newArray[indexPath.row].dateUtc
    //
    //        if newArray[indexPath.row].success != nil {
    //            if newArray[indexPath.row].success! {
    //                cell.rocketImage.image = UIImage(named: "rocketTrue")
    //            } else {
    //                cell.rocketImage.image = UIImage(named: "rocketFalse")
    //            }
    //        } else {
    //            cell.rocketImage.image = UIImage(named: "unknown")
    //        }
    //        return cell
    //    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
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





//        launchesTable.delegate = self
//        title = "Запуски"
//        launchesTable.register(UINib(nibName: "RocketCell", bundle: nil),
//                                 forCellReuseIdentifier: "RocketCell")
//        networkAPI.getLaunches { [self] (result) in
//            switch result {
//            case .success(let launches):
//                print(launches)
//                for element in launches {
//                    self.newArray.append(element)
//                }
//                self.launchesTable.reloadData()
//            case .failure(_):
//                print("Error")
//            }
//        }
