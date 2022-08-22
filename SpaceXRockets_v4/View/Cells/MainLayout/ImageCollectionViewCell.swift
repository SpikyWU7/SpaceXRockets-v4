import UIKit

protocol CallSettingsVCProtocol {
    func presentSettingsViewController()
}

final class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var rocketImage: UIImageView!
    @IBOutlet private var rocketName: UILabel!
    @IBOutlet private var labelView: UIView!
    var cellDelegate: CallSettingsVCProtocol!

    var image: UIImage? {
        didSet {
            rocketImage.image = image
        }
    }

    static var reuseId: String = "ImageCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        labelView.layer.cornerRadius = 25
    }
    @IBAction private func presentSettingsViewController(_ sender: UIButton) {
        self.cellDelegate.presentSettingsViewController()
    }

    func configure(with info: Cell) {
        rocketName.text = info.value
    }
}
