//
//  RocketName.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 24.06.2022.
//

import Foundation
import UIKit

struct RocketImageLabel: Decodable, Hashable {
    let name: String
    let flickrImages: String
}

extension RocketImageLabel {
    static func getData() -> [RocketImageLabel] {
        let rocket1 = RocketImageLabel(name: "Falcon Heavy 9", flickrImages: "f")
        return [rocket1]
    }
}
