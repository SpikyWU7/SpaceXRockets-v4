//
//  SettingsViewController.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 15.07.2022.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var segmentHeight: UISegmentedControl!
    @IBOutlet var segmentDiameter: UISegmentedControl!
    @IBOutlet var segmentMass: UISegmentedControl!
    @IBOutlet var segmentPayload: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func heightChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.isSelected ? "kg" : "lb", forKey: "Mass")
    }

    @IBAction func diameterChanged(_ sender: UISegmentedControl) {
    }

    @IBAction func massChanged(_ sender: UISegmentedControl) {
    }

    @IBAction func payloadChanged(_ sender: UISegmentedControl) {
    }


}
