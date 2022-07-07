//
//  ImageCollectionViewCell.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 24.06.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var rocketImage: UIImageView!
    @IBOutlet var rocketName: UILabel?
    @IBOutlet var labelView: UIView!

    static var reuseId : String = "ImageCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        labelView.layer.cornerRadius = 15
    }

    @IBAction func settingsButton() {
    }

    func configure(with info: Cell) {
        rocketName?.text = info.value
    }


}
