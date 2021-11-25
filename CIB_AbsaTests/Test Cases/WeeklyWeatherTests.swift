//
//  WeeklyWeatherTests.swift
//  CIB_AbsaTests
//
//  Created by Morris Mwangi on 25/11/2021.
//

import XCTest
import Combine
@testable import CIB_Absa

class WeeklyWeatherTests: XCTestCase {

    // MARK: - Properties
    var viewModel: WeatherViewModel!
    var weatherResponse: WeeklyWeatherResponse!
    var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        viewModel = WeatherViewModel()
        try loadStubData()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        weatherResponse = nil
        subscriptions = []
    }

    /// Load sample weather data for the current day
    func loadStubData() throws {
        // Load Stub
        let data = loadStub(name: "weeklyDataStub", extension: "json")

        // Create JSON Decoder
        let decoder = JSONDecoder()

        // Decode JSON
        let weatherData = try decoder.decode(WeeklyWeatherResponse.self, from: data)

        // Set weather data
        weatherResponse = weatherData
    }

    /// Test validity of current weather url
    func testCurrentWeatherUrl() {
        XCTAssertEqual(viewModel.weeklyWeatherUrl, Services.weeklyWeatherData, "Incorrent weekly weather url")
    }

    /// Test that the right number of records are decoded
    func testNumberOfRecordsReturned() {
        XCTAssertEqual(weatherResponse.list.count, 40)
    }

    /// Test weather data decoded to expected format
    func testDataDecodedSuccessfully() {
        XCTAssertNotNil(weatherResponse, "Weather data decoded successfully")
        XCTAssertEqual(weatherResponse.list.first?.visibility, 10000)
    }

    /// Ensure date exists and can be converted to day of the week successfully
    func testDateValidity() {
        XCTAssertNotNil(weatherResponse.list.first?.dt_txt, "Date not set")
        XCTAssertEqual(weatherResponse.list.first?.dt_txt.dayofWeek(), "Nov 25 2021 12:00 PM", "Date not converted correctly")
    }

    /// Ensure all mandatory data to be displayed to user exists
    func testMandatoryDataNotEmpty() {
        XCTAssertNotNil(weatherResponse.list.first?.main.temp, "Temperature not set")
        XCTAssertNotNil(weatherResponse.list.first?.main.temp_min, "Min Temperature not set")
        XCTAssertNotNil(weatherResponse.list.first?.main.temp_max, "Max Temperature not set")
        XCTAssertNotNil(weatherResponse.list.first?.main.humidity, "Humidity not set")
        XCTAssertNotNil(weatherResponse.list.first?.visibility, "Visibility not available")
        XCTAssertNotNil(weatherResponse.list.first?.wind.speed, "Wind speed not available")
    }

    /// Ensure all mandatory data to be displayed to user is correct
    func testMandatoryDataValidity() {
        XCTAssertEqual(weatherResponse.list.first?.main.temp, 284.59)
        XCTAssertEqual(weatherResponse.list.first?.main.temp_min, 284.38)
        XCTAssertEqual(weatherResponse.list.first?.main.temp_max, 284.59)
        XCTAssertEqual(weatherResponse.list.first?.main.humidity, 54)
        XCTAssertEqual(weatherResponse.list.first?.visibility, 10000)
        XCTAssertEqual(weatherResponse.list.first?.wind.speed, 3.37)
    }

    /// Ensure the weather icon is retrieved in the right format
    func testWeatherIconValidity() throws {
        let weatherIcon = try XCTUnwrap(weatherResponse.list.first?.weather.first?.main)
        XCTAssertEqual(weatherIcon, .clouds)
    }

    /// Ensure that the main temperature is converted to celsius correctly
    func testTemperatureConversionValidity() {
        XCTAssertEqual(weatherResponse.list.first?.main.temp.toCelsius(), "11.44°C")
    }

    /// Test that weather data stream is subscribed to and observed correctly.
    ///
    /// This also checks validity of data being streamed
    func testReceivedDataObservable() {
        let ex = XCTestExpectation()

        // create subscription first
        viewModel.weeklyWeatherData.sink { completion in
            ex.fulfill()
        } receiveValue: { response in
            XCTAssertNotNil(response)
            ex.fulfill()
        }.store(in: &subscriptions)

        // send data to be observed to subscription
        viewModel.weeklyWeatherData.send(weatherResponse)

        wait(for: [ex], timeout: 1)
    }

    /// Checks that the loader is displayed and dismissed to user correctly
    func testLoadingAnimationObservable() {
        let ex = XCTestExpectation()

        // create subscription first
        viewModel.showWeeklyWeatherLoader.sink { completion in
            ex.fulfill()
        } receiveValue: { show in
            XCTAssertEqual(show, true)
            ex.fulfill()
        }.store(in: &subscriptions)

        // send data to be observed to subscription
        viewModel.showWeeklyWeatherLoader.send(true)

        wait(for: [ex], timeout: 1)
    }

    /// Ensure data is decoded quick enough and displayed to user
    ///
    /// Current baseline is set to 0.023 seconds
    func testDecodeDataPerformance() throws {
        // This is an example of a performance test case.
        self.measure {
            try! loadStubData()
        }
    }
}
