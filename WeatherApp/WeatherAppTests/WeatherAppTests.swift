import XCTest
import OHHTTPStubs
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
	var service: WeatherService = OpenWeatherMapService()

    override func setUp() {
        super.setUp()
		service = OpenWeatherMapService()
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    func testShouldGetWeatherByCity() {
		let expect = expectation(description: "forecast search")
		stub(condition: isHost("api.openweathermap.org") && isPath("/data/2.5/weather")) { _ in
			return OHHTTPStubsResponse(
					fileAtPath: OHPathForFile("CurrentWeather.json", type(of: self))!,
					statusCode: 200,
					headers: ["Content-Type": "application/json"]
				)
			}

		service.getWeatherByCity(city: "Hillsboro", completion: { (response) in
			XCTAssertTrue(response.location.name == "Hillsboro")
			print(response)
			expect.fulfill()
		}, failure: { (_) in
			XCTFail("should not have failed")
			expect.fulfill()
		})
		waitForExpectations(timeout: 1) { error in
			if let error = error {
				XCTFail("waitForExpectationsWithTimeout errored: \(error)")
			}
		}
    }
}
