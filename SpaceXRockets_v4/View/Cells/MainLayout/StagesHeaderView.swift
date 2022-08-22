import Foundation
import UIKit

final class StagesHeaderView: UICollectionReusableView {

    @IBOutlet private var stageLabel: UILabel!

    static var reuseId : String = "StagesHeaderView"

    override func awakeFromNib() {
        super.awakeFromNib()
        stageLabel.text = "Первая/вторая ступень"
    }

    func configure(with title: String) {
        stageLabel.text = title
    }

}
