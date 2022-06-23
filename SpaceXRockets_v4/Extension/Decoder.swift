//
//  Decoder.swift
//  SpaceXRockets_v4
//
//  Created by Spiky WU7 on 21.06.2022.
//

import Foundation
import UIKit

extension Bundle {
        func decode<T: Decodable>(_ type: T.Type, from filename: String) -> T? {
            guard let json = url(forResource: filename, withExtension: nil) else {
                print("Failed to locate \(filename) in app bundle.")
                return nil
            }
        do {
            let jsonData = try Data(contentsOf: json)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(T.self, from: jsonData)
            return result
        } catch {
            print("Failed to load and decode JSON \(error)")
            return nil
        }

    }

}
