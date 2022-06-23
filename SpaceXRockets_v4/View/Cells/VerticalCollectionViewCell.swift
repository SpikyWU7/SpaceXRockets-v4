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
    private var model: RocketMainInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with model: RocketMainInfo) {

        self.model = model
        self.rightLabel.text = model.country
    }
}