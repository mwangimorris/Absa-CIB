//
//  WeatherViewModel.swift
//  CIB_Absa
//
//  Created by Morris Mwangi on 24/11/2021.
//

import Combine

struct WeatherViewModel {

    // MARK: - Properties
    var apiClient: APIClient?

    // Current Weather endpoint
    let currentWeatherUrl = Services.currentWeatherData
    let weeklyWeatherUrl = Services.weeklyWeatherData

    // Observe data changes and update UI
    let showCurrentWeatherLoader = PassthroughSubject<Bool, Never>()
    let showWeeklyWeatherLoader = PassthroughSubject<Bool, Never>()
    let showWeatherDataError = PassthroughSubject<String, Never>()
    let dailyWeatherData = PassthroughSubject<WeatherResponse, Error>()
    let weeklyWeatherData = PassthroughSubject<WeeklyWeatherResponse, Error>()

    // FIXIT: - Should be stored securely in the KeyChain
    let apiKey: String = "f26d6f7dd978aa98e7142ce2c8ff5813"

    public func getCurrentWeatherData(at coordinates: Coordinates) {
        showCurrentWeatherLoader.send(true)

        let url = String(format: currentWeatherUrl, coordinates.description, apiKey)

        apiClient?.getRequest(for: WeatherResponse.self, url: url, completionHandler: { result in
            showCurrentWeatherLoader.send(false)
            switch result {
            case .success(let weatherData):
                guard let decodedData = weatherData else {
                    showWeatherDataError.send(NetworkError.decodingError.localizedDescription)
                    return
                }
                self.dailyWeatherData.send(decodedData)
            case .failure(let error):
                showWeatherDataError.send(error.localizedDescription)
            }
        })
    }

    public func getWeeklyWeatherData(at coordinates: Coordinates) {
        showWeeklyWeatherLoader.send(true)

        let url = String(format: weeklyWeatherUrl, coordinates.description, apiKey)

        apiClient?.getRequest(for: WeeklyWeatherResponse.self, url: url, completionHandler: { result in
            showWeeklyWeatherLoader.send(false)
            switch result {
            case .success(let weatherData):
                guard let decodedData = weatherData else {
                    showWeatherDataError.send(NetworkError.decodingError.localizedDescription)
                    return
                }
                self.weeklyWeatherData.send(decodedData)
            case .failure(let error):
                showWeatherDataError.send(error.localizedDescription)
            }
        })
    }
}
