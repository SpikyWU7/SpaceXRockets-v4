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

    override func viewDidLoad() {
        super.viewDidLoad()
        launchesTable.dataSource = self
        launchesTable.backgroundColor = .blue
        launchesTable.register(UINib(nibName: RocketCell.reuseId, bundle: nil), forCellReuseIdentifier: RocketCell.reuseId)




//        networkAPI.getLaunches { [self] (result) in
//            switch result {
//            case .success(let launches):
//                for element in launches {
//                    if element.rocket == rocketID! && rocketID != nil {
//                        self.newArray.append(element)
//                    }
//                }
//                self.launchesTable.reloadData()
//            case .failure(_):
//                print("Error")
//            }
//        }
    }

    @IBAction private func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension LaunchesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = launchesTable.dequeueReusableCell(withIdentifier: "RocketCell", for: indexPath) as? RocketCell {
            cell.setData(text: dataArray[indexPath.row])
            return cell
        }

        return UITableViewCell()
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
