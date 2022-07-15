//
//  LaunchDates.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 12.07.2022.
//

import Foundation

struct LaunchDates: Decodable {
    let name: String?
    let success: Bool?
    var dateUtc: String
    var rocket: String
}
