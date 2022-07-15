//
//  ButtonCollectionViewCell.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 24.06.2022.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet var launchesButton: UIButton!
    static var reuseId : String = "ButtonCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        launchesButton.layer.cornerRadius = 30.0
    }

    @IBAction func launchesButtonPressed() {
        self.window?.rootViewController!.present(LaunchesViewController(), animated: true, completion: nil)
    }
}
