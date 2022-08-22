import Foundation
import UIKit

enum Params: String {
    case height = "Height"
    case diameter = "Diameter"
    case mass = "Mass"
    case payweight = "PayloadWeights"
    case m = "m"
    case ft = "ft"
    case kg = "kg"
    case lb = "lb"
}

extension String {
    static func strToDate(string: String, fromDate: String) -> String {
        let formatGet = DateFormatter()
        let formatSet = DateFormatter()
        let strDate: String
        formatGet.dateFormat = fromDate
        formatSet.dateFormat = "d MMMM, yyyy"
        guard let date = formatGet.date(from: string) else {
            return "error formatting strToDate"
        }
        strDate = formatSet.string(from: date)
        return strDate
    }
}
