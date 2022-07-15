//
//  ButtonCollectionViewCell.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 24.06.2022.
//

import UIKit

protocol CallLaunchesVCProtocol {
    func presentLaunchesViewController()
}

class ButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet var launchesButton: UIButton!
    static var reuseId : String = "ButtonCollectionViewCell"
    var cellDelegate: CallLaunchesVCProtocol!

    override func awakeFromNib() {
        super.awakeFromNib()
        launchesButton.layer.cornerRadius = 30.0
    }

    @IBAction func launchesButtonPressed(_ sender: UIButton) {
        self.cellDelegate.presentLaunchesViewController()
    }
}
