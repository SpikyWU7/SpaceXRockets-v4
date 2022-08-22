import UIKit

protocol CallLaunchesVCProtocol {
    func presentLaunchesViewController()
}

final class ButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var launchesButton: UIButton!
    static var reuseId : String = "ButtonCollectionViewCell"
    var cellDelegate: CallLaunchesVCProtocol!

    override func awakeFromNib() {
        super.awakeFromNib()
        launchesButton.layer.cornerRadius = 15.0
    }

    @IBAction func launchesButtonPressed(_ sender: UIButton) {
        self.cellDelegate.presentLaunchesViewController()
    }
}
