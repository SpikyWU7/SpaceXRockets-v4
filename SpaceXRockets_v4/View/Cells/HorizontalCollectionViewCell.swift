//
//  HorziontalCollectionViewCell.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 21.06.2022.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {

    static var reuseId : String = "HorizontalCollectionViewCell"
    private var model: RocketModel!

    @IBOutlet var upLabel: UILabel!
    @IBOutlet var downLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with model: RocketModel) {

        self.model = model
        self.upLabel.text = String("\(model.height.feet)")
    }

}
