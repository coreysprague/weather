import XCTest
import OHHTTPStubs
import CoreLocation
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
	var service: WeatherService = OpenWeatherMapService()

	let expectedWeatherResponse = CurrentWeatherResponse(
							location: ForecastLocation(
								latitude: 45.52,
								longitude: -122.99,
								locationId: 5731371,
								name: "Hillsboro",
								country: "US",
								sunrise: Date(timeIntervalSince1970: 1506175254),
								sunset: Date(timeIntervalSince1970: 1506218788)
							),
							conditions: [
								WeatherCondition(
									conditionId: 800,
									main: "Clear",
									description: "clear sky"
								)
							],
							weather: Weather(
								temperature: Measurement<UnitTemperature>(value: 287.75, unit: .kelvin),
								pressure: Measurement<UnitPressure>(value: 1018, unit: .hectopascals),
								humidity: 82
							),
							visibility: Measurement<UnitLength>(value: 16093, unit: .meters),
							wind: Wind(
								speed: Measurement<UnitSpeed>(value: 1.5, unit: .metersPerSecond),
								deg: Measurement<UnitAngle>(value: 340, unit: .radians)
							),
							lastUpdated: Date(timeIntervalSince1970: 1506138960)
	)

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
			XCTAssertEqual(self.expectedWeatherResponse, response)
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
