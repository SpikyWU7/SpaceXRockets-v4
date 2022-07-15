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

    @IBOutlet var cellView: UIView!
    @IBOutlet var upLabel: UILabel!
    @IBOutlet var downLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 25.0
    }

    func configure(with model: Cell) {
        self.upLabel.text = model.value
        self.downLabel.text = model.title
    }

}
