import Foundation
import UIKit

enum Params: String {
    case height = "Height"
    case diameter = "Diameter"
    case mass = "Mass"
    case payweight = "PayloadWeights"
    // swiftlint: disable identifier_name
    case m = "m"
    case ft = "ft"
    case kg = "kg"
    case lb = "lb"
}

extension String {
    func strToDate(string: String) -> String {
        let formatGet = DateFormatter()
        let formatSet = DateFormatter()
//        var date: Date
        let strDate: String
        formatGet.dateFormat = "yyyy-MM-dd"
        formatSet.dateFormat = "d MMMM, yyyy"
        guard let date = formatGet.date(from: string) else { return "error formatting strToDate" }
        strDate = formatSet.string(from: date)
        return strDate
    }
}
