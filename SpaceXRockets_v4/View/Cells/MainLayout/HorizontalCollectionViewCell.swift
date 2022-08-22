import UIKit

final class HorizontalCollectionViewCell: UICollectionViewCell {

    static var reuseId : String = "HorizontalCollectionViewCell"
    private var model: RocketModel!

    @IBOutlet private var cellView: UIView!
    @IBOutlet private var upLabel: UILabel!
    @IBOutlet private var downLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 30.0
    }

    func configure(with model: Cell) {
        self.upLabel.text = model.value
        self.downLabel.text = model.title
    }

}
