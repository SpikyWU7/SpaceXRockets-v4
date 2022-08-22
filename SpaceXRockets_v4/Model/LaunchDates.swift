import Foundation

struct LaunchDates: Decodable {
    let name: String?
    let success: Bool?
    var dateUtc: String
    var rocket: String
}
