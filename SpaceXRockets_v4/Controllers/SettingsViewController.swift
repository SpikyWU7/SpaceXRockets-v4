//
//  SettingsViewController.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 15.07.2022.
//

import Foundation
import UIKit

struct K {
    static let height = "Height"
    static let diameter = "Diameter"
    static let mass = "Mass"
    static let payweight = "PayloadWeights"
}

class SettingsViewController: UIViewController {

    @IBOutlet var heightSegControl: UISegmentedControl!
    @IBOutlet var diameterSegControl: UISegmentedControl!
    @IBOutlet var massSegControl: UISegmentedControl!
    @IBOutlet var payweightSegControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentState()
    }

    private func setupSegmentState() {
        if UserDefaults.standard.string(forKey: K.height) ==  "m" {
            heightSegControl.selectedSegmentIndex = 1
        } else {
            heightSegControl.selectedSegmentIndex = 0
        }
        if UserDefaults.standard.string(forKey: K.diameter) ==  "m" {
            diameterSegControl.selectedSegmentIndex = 1
        } else {
            diameterSegControl.selectedSegmentIndex = 0
        }
        if UserDefaults.standard.string(forKey: K.mass) ==  "kg" {
            massSegControl.selectedSegmentIndex = 1
        } else {
            massSegControl.selectedSegmentIndex = 0
        }
        if UserDefaults.standard.string(forKey: K.payweight) ==  "kg" {
            payweightSegControl.selectedSegmentIndex = 1
        } else {
            payweightSegControl.selectedSegmentIndex = 0
        }
    }

    @IBAction func heightChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set((sender.selectedSegmentIndex != 0) ? "m" : "ft", forKey: K.height)
    }

    @IBAction func diameterChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set((sender.selectedSegmentIndex != 0) ? "m" : "ft", forKey: K.diameter)
    }

    @IBAction func massChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set((sender.selectedSegmentIndex != 0) ? "kg" : "lb", forKey: K.mass)
    }

    @IBAction func payweightChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set((sender.selectedSegmentIndex != 0) ? "kg" : "lb", forKey: K.payweight)
    }

    @IBAction func dismissPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
