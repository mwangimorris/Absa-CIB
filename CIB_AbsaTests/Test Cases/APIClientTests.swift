//
//  APIClientTests.swift
//  CIB_AbsaTests
//
//  Created by Morris Mwangi on 25/11/2021.
//

import XCTest
@testable import CIB_Absa

class APIClientTests: XCTestCase {

    // MARK: - Properties
    var testURL: String?
    var apiClientMock: APIClientMock?
    var weatherResponse: WeatherResponse!

    override func setUpWithError() throws {
        apiClientMock = APIClientMock()
        testURL = "test/api"

        // Do a mock fetch
        loadDataFromMockApi()
    }

    override func tearDownWithError() throws {
        testURL = nil
        apiClientMock = nil
        weatherResponse = nil
    }

    func loadDataFromMockApi()  {

        guard let testUrl = self.testURL else {
            XCTFail("URL not found")
            return
        }

        apiClientMock?.getRequest(for: WeatherResponse.self, url: testUrl, completionHandler: { result in
            switch result {
            case .success(let data):
                self.weatherResponse = data
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
    }

    /// Test that data is received from the mock
    func testDataFetchedCorrectly() {
        XCTAssertNotNil(weatherResponse)
    }

    /// Test that data received is decoding correctly
    func testReceivedDataValidity() {
        XCTAssertEqual(weatherResponse.name, "SanFranco")
    }

    /// Test that the url supplied is not empty
    func testUrlValidity() {
        apiClientMock?.getRequest(for: WeatherResponse.self, url: "", completionHandler: { result in
            XCTAssertEqual(result, .failure(NetworkError.badURL))
        })
    }
}
