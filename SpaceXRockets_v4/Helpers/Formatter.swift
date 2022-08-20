import Foundation
import UIKit

class Format {
    static let formatter = Format()
    let dateFormatter = DateFormatter()
    let formatGet = DateFormatter()
    let formatSet = DateFormatter()

    func strToDate(string: String) -> String {
        var date: Date
        let strDate: String
        formatGet.dateFormat = "yyyy-MM-dd"
        formatSet.dateFormat = "d MMMM, yyyy"
        date = formatGet.date(from: string)!
        strDate = formatSet.string(from: date)
        return strDate
    }

    func numToStr(_ number: Double) -> String {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        guard let result = format.string(from: number as NSNumber) else { return "error formatting numToStr" }
        return "\(result)"
    }

    func formatNums(value: Double) -> String {
        String(format: "%.0f", value)
    }
}

struct K {
    static let height = "Height"
    static let diameter = "Diameter"
    static let mass = "Mass"
    static let payweight = "PayloadWeights"
    static let m = "m"
    static let ft = "ft"
    static let kg = "kg"
    static let lb = "lb"
}

//let date = Date()
//let format = date.getFormattedDate(format: "yyyy-MM-dd") // Set output format
//
//extension Date {
//   func getFormattedDate(format: String) -> String {
//        let dateformat = DateFormatter()
//        dateformat.dateFormat = format
//        return dateformat.string(from: self)
//    }
//}

extension String {
    func strToDate(string: String) -> String {
        let formatGet = DateFormatter()
        let formatSet = DateFormatter()
        var date: Date
        let strDate: String
        formatGet.dateFormat = "yyyy-MM-dd"
        formatSet.dateFormat = "d MMMM, yyyy"
        date = formatGet.date(from: string)!
        strDate = formatSet.string(from: date)
        return strDate
    }
}
