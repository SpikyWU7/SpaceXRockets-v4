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
        self.rightLabel.text = model.value
    }
}
