//
//  APIClientMock.swift
//  CIB_AbsaTests
//
//  Created by Morris Mwangi on 25/11/2021.
//

import XCTest
@testable import CIB_Absa

class APIClientMock: NetworkEngine {

    func getRequest<T>(for: T.Type, url: String, completionHandler completion: @escaping (Result<T?, NetworkError>) -> Void) where T : Decodable {
        guard !url.isEmpty else { return completion(.failure(.badURL)) }

        let sampleResponse = WeatherResponse(coord: Coordinates(lat: 37.125, lon: -127.25),
                                             main: CurrentWeather(temp: 123.5, temp_min: 123.1, temp_max: 123.8, humidity: 25),
                                             weather: [Weather(description: "very cloudy", icon: "1sg", id: 3, main: MainEnum(rawValue: "Clear")!)],
                                             sys: CountryDetails(country: "US"), name: "SanFranco")

        completion(.success(sampleResponse as? T))
    }

}
