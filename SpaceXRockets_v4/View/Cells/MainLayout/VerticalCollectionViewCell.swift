import UIKit

final class VerticalCollectionViewCell: UICollectionViewCell {

    static var reuseId: String = "VerticalCollectionViewCell"

    @IBOutlet private var leftLabel: UILabel!
    @IBOutlet private var rightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with model: Cell) {
        self.leftLabel.text = model.title
        if model.value == "United States" {
            self.rightLabel.text = NSLocalizedString("United States", comment: "")
        } else if model.value == "Republic of the Marshall Islands" {
            self.rightLabel.text = NSLocalizedString("Republic of the Marshall Islands", comment: "")
        } else {
        self.rightLabel.text = model.value
        }
    }
}
