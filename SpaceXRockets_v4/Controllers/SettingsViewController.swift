import Foundation
import UIKit

final class SettingsViewController: UIViewController {

    @IBOutlet private var heightSegControl: UISegmentedControl!
    @IBOutlet private var diameterSegControl: UISegmentedControl!
    @IBOutlet private var massSegControl: UISegmentedControl!
    @IBOutlet private var payweightSegControl: UISegmentedControl!
    private var segmentChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentState()
    }

    @IBAction private func heightChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(
            (sender.selectedSegmentIndex != 0)
            ? Params.m.rawValue
            : Params.ft.rawValue,
            forKey: Params.height.rawValue
        )
        segmentChanged = true
    }

    @IBAction private func diameterChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(
            (sender.selectedSegmentIndex != 0)
            ? Params.m.rawValue
            : Params.ft.rawValue,
            forKey: Params.diameter.rawValue
        )
        segmentChanged = true
    }

    @IBAction private func massChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(
            (sender.selectedSegmentIndex != 0)
            ? Params.kg.rawValue
            : Params.lb.rawValue,
            forKey: Params.mass.rawValue
        )
        segmentChanged = true
    }

    @IBAction private func payweightChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(
            (sender.selectedSegmentIndex != 0)
            ? Params.kg.rawValue
            : Params.lb.rawValue,
            forKey: Params.payweight.rawValue
        )
        segmentChanged = true
    }

    @IBAction private func dismissPressed(_ sender: UIButton) {
        if segmentChanged {
            NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
        }
        self.presentingViewController?.dismiss(animated: true)
    }
}

// MARK: - setupSegmentState

extension SettingsViewController {
    private func setupSegmentState() {
        UserDefaults.standard.string(forKey: Params.height.rawValue) == Params.m.rawValue
        ? (heightSegControl.selectedSegmentIndex = 1)
        : (heightSegControl.selectedSegmentIndex = 0)
        UserDefaults.standard.string(forKey: Params.diameter.rawValue) == Params.m.rawValue
        ? (diameterSegControl.selectedSegmentIndex = 1)
        : (diameterSegControl.selectedSegmentIndex = 0)
        UserDefaults.standard.string(forKey: Params.mass.rawValue) == Params.kg.rawValue
        ? (massSegControl.selectedSegmentIndex = 1)
        : (massSegControl.selectedSegmentIndex = 0)
        UserDefaults.standard.string(forKey: Params.payweight.rawValue) == Params.kg.rawValue
        ? (payweightSegControl.selectedSegmentIndex = 1)
        : (payweightSegControl.selectedSegmentIndex = 0)
    }
}
