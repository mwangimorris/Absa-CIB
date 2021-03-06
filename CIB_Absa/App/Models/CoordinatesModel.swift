//
//  CoordinatesModel.swift
//  CIB_Absa
//
//  Created by Morris Mwangi on 24/11/2021.
//

import Foundation

// MARK: - Coordinates to be passed to fetch weather data
struct Coordinates: Decodable {
    let lat: Double
    let lon: Double
}

// MARK: - Simplify coordinate value parameters
extension Coordinates: CustomStringConvertible {
    var description: String {
        return "lat=\(lat)&lon=\(lon)"
    }
}
