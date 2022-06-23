//
//  MChat.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 21.06.2022.
//

import Foundation
import UIKit

struct MChat: Decodable, Hashable {
    let friendName: String
    let friendImage: String
    let lastMessage: String
}
