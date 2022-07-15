//
//  MSection.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 21.06.2022.
//

import Foundation
import UIKit

struct MSection: Decodable, Hashable {
    let type: String
    let title: String
    let items: [MChat]
}

