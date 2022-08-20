//
//  VerticalCollectionViewCell.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 21.06.2022.
//

import UIKit

class VerticalCollectionViewCell: UICollectionViewCell {

    static var reuseId : String = "VerticalCollectionViewCell"

    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with model: Cell) {
        self.leftLabel.text = model.title
        if model.value == "United States" {
            self.rightLabel.text = NSLocalizedString("United States", comment: "")
        } else if model.value == "Republic of the Marshall Islands" {
            self.rightLabel.text = NSLocalizedString("Republic of the Marshall Islands", comment: "")
        } else {
        self.rightLabel.text = model.value
        }
    }
}
