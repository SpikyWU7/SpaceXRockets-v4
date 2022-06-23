import Foundation

struct RocketModel: Decodable, Hashable {

    let name: String
    let firstFlight: String
    let country: String
    let costPerLaunch: Double
    let firstStage: FirstStage
    let secondStage: SecondStage
    let flickrImages: [String]
    let height: Height
    let diameter: Diameter
    let mass: Mass
    let payloadWeights: [PayloadWeights]
    let id: String

    var launchCost: String {
        String(format: "$%.0f млн.", costPerLaunch / 1000000)
    }
}

extension RocketModel {

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
