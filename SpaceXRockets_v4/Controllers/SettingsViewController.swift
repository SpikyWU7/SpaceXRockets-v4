//
//  SettingsViewController.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 15.07.2022.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }

}
