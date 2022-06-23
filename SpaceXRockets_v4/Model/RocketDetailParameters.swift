//
//  RocketDetailParameters.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 22.06.2022.
//

import Foundation

struct RocketDetailParameters: Decodable, Hashable {
    let height: Height
    let diameter: Diameter
    let mass: Mass
    let payloadWeights: [PayloadWeights]
}

extension RocketDetailParameters {
    struct Height: Decodable, Hashable {
        let meters: Double
        let feet: Double
    }

    struct Diameter: Decodable, Hashable {
        let meters: Double
        let feet: Double
    }

    struct Mass: Decodable, Hashable {
        let kg: Double
        let lb: Double
    }

    struct PayloadWeights: Decodable, Hashable {
        let kg: Double
        let lb: Double
    }
} 
