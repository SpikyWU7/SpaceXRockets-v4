//
//  StagesHeaderView.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 11.07.2022.
//

import Foundation
import UIKit

class StagesHeaderView: UICollectionReusableView {

    @IBOutlet var stageLabel: UILabel!

    static var reuseId : String = "StagesHeaderView"

    override func awakeFromNib() {
        super.awakeFromNib()
        stageLabel.text = "Первая/вторая ступень"
    }

    func configure(with title: String) {
        stageLabel.text = title
    }

}
