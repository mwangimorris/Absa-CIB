//
//  Services.swift
//  CIB_Absa
//
//  Created by Morris Mwangi on 24/11/2021.
//

import Foundation

// MARK: - Fetch Weather Data services for current and weekly
struct Services {
    static let currentWeatherData = "https://api.openweathermap.org/data/2.5/weather?%@&appid=%@"
    static let weeklyWeatherData = "https://api.openweathermap.org/data/2.5/forecast?%@&appid=%@"
}
