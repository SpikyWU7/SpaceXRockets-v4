import Foundation
import UIKit

struct K {
    static let height = "Height"
    static let diameter = "Diameter"
    static let mass = "Mass"
    static let payweight = "PayloadWeights"
    static let m = "m"
    static let ft = "ft"
    static let kg = "kg"
    static let lb = "lb"
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

    @IBAction func heightChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set((sender.selectedSegmentIndex != 0) ? K.m : K.ft, forKey: K.height)
    }

    @IBAction func diameterChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set((sender.selectedSegmentIndex != 0) ? K.m : K.ft, forKey: K.diameter)
    }

    @IBAction func massChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set((sender.selectedSegmentIndex != 0) ? K.kg : K.lb, forKey: K.mass)
    }

    @IBAction func payweightChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set((sender.selectedSegmentIndex != 0) ? K.kg : K.lb, forKey: K.payweight)
    }

    @IBAction func dismissPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
    }
}

extension SettingsViewController {
    private func setupSegmentState() {
        UserDefaults.standard.string(forKey: K.height) == K.m
        ? (heightSegControl.selectedSegmentIndex = 1)
        : (heightSegControl.selectedSegmentIndex = 0)
        UserDefaults.standard.string(forKey: K.diameter) == K.m
        ? (diameterSegControl.selectedSegmentIndex = 1)
        : (diameterSegControl.selectedSegmentIndex = 0)
        UserDefaults.standard.string(forKey: K.mass) == K.kg
        ? (massSegControl.selectedSegmentIndex = 1)
        : (massSegControl.selectedSegmentIndex = 0)
        UserDefaults.standard.string(forKey: K.payweight) == K.kg
        ? (payweightSegControl.selectedSegmentIndex = 1)
        : (payweightSegControl.selectedSegmentIndex = 0)
    }
}
