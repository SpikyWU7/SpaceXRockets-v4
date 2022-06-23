//
//  RocketMainInfo.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 22.06.2022.
//

import Foundation

struct RocketMainInfo: Decodable, Hashable {
    let name: String
    let firstFlight: String
    let country: String
    let costPerLaunch: Double
    let firstStage: FirstStage
    let secondStage: SecondStage
    let flickrImages: [String]
    let id: String

    var launchCost: String {
        String(format: "$%.0f млн.", costPerLaunch / 1000000)
    }
}

extension RocketMainInfo {
    struct FirstStage: Decodable, Hashable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTime: Int?
    }

    struct SecondStage: Decodable, Hashable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTime: Int?
    }
}
