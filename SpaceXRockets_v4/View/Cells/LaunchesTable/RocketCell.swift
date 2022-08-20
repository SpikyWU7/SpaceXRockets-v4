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

    override func layoutSubviews() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 15))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        rocketView.layer.cornerRadius = 25
        rocketView.layer.masksToBounds = true
    }

    func initCell(with data: LaunchDates) {
        rocketCellLabel.text = data.name
    }
}
