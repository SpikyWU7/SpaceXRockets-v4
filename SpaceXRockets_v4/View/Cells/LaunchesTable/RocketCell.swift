//
//  File.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 13.07.2022.
//

import Foundation
import UIKit

class RocketCell: UITableViewCell {
    @IBOutlet var rocketView: UIView!
    @IBOutlet var rocketCellLabel: UILabel!
    @IBOutlet var rocketCellDate: UILabel!
    @IBOutlet var rocketImage: UIImageView!
    static let reuseId = "RocketCell"

//    let format = Format()

    override func awakeFromNib() {
        super.awakeFromNib()
        rocketView.layer.cornerRadius = rocketView.frame.size.height / 25
    }

    func initCell(with data: LaunchDates) {
            rocketCellLabel.text = data.name
        rocketCellDate.text = data.dateUtc
        
//            rocketCellDate.text = format.strToDate(date: data.dateUtc)

        if let data = data.success { // Fix логику убрать из ячейки передавать уже выбранную картинку
            if data {
                rocketImage.image = UIImage(named: "rocketTrue")
            } else {
                rocketImage.image = UIImage(named: "rocketFalse")
            }
        } else {
            rocketImage.image = UIImage(named: "unknown")
        }
    }

    func setData(text: String) {
        self.rocketCellLabel.text = text
    }
}
