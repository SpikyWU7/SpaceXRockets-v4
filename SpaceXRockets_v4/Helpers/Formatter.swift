import Foundation
import UIKit

class Format {
    func strToDate(date: Date) -> String {
        var strDate: String
        let dataFormat = DateFormatter() // Fix а почему форматтер каждый раз заново создается
        dataFormat.locale = .current
        dataFormat.dateStyle = .long
        strDate = dataFormat.string(from: date)
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
func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
  let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
  let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
  let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
  let range = (self as NSString).range(of: text)
  fullString.addAttributes(boldFontAttribute, range: range)
  return fullString
}}
