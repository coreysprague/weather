import XCTest
import OHHTTPStubs
import CoreLocation
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
	var service: WeatherService = OpenWeatherMapService()
	var expect: XCTestExpectation?

    override func setUp() {
        super.setUp()
		expect = expectation(description: "weather service search")
		service = OpenWeatherMapService()
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    func testSuccessfulWeatherSearchByCity() {
		givenCurrentForecastSearchWillSucceed(forValidCity)
		service.getWeatherByCity(
			city: validCity,
			completion: assertCurrentWeather,
			failure: assertDidNotFail
		)
		failIfNeitherCallbackInvoked()
    }

	func testSuccessfulWeatherSearchByCityId() {
		givenCurrentForecastSearchWillSucceed(forValidCityId)
		service.getWeatherByCityId(
			cityId: validCityId,
			completion: assertCurrentWeather,
			failure: assertDidNotFail
		)
		failIfNeitherCallbackInvoked()
	}

	func testSuccessfulWeatherSearchByZipCode() {
		givenCurrentForecastSearchWillSucceed(forValidZip)
		service.getWeatherByZipcode(
			zipCode: validZip,
			completion: assertCurrentWeather,
			failure: assertDidNotFail
		)
		failIfNeitherCallbackInvoked()
	}

	func testSuccessfulWeatherSearchByLocation() {
		givenCurrentForecastSearchWillSucceed(forValidCoordinates)
		service.getWeatherByLocation(location: validCoordinates,
			completion: assertCurrentWeather,
			failure: assertDidNotFail
		)
		failIfNeitherCallbackInvoked()
	}

	func testSuccessfulHourlyForecastSearch() {
		givenHourlyForecastSearchWillSucceed(forValidCityId)
		service.getHourlyForecastByCityId(
			cityId: validCityId,
			completion: assertHourlyForecast
		)
		failIfNeitherCallbackInvoked()
	}

	func testSuccessfulDailyForecastSearch() {
		givenDailyForecastSearchWillSucceed(forValidCityId)
		service.getDailyForecastByCityId(
			cityId: validCityId,
			completion: assertDailyForecast
		)
		failIfNeitherCallbackInvoked()
	}

	func testFailedWeatherSearchByCity() {
		givenCurrentForecastSearchWillFail(forInvalidCity)
		service.getWeatherByCity(
			city: invalidCity,
			completion: assertCallbackNotInvoked,
			failure: assertFailureCallbackInvoked
		)
		failIfNeitherCallbackInvoked()
	}

	func testFailedWeatherSearchByCityId() {
		givenCurrentForecastSearchWillFail(forInvalidCityId)
		service.getWeatherByCityId(
			cityId: invalidCityId,
			completion: assertCallbackNotInvoked,
			failure: assertFailureCallbackInvoked
		)
		failIfNeitherCallbackInvoked()
	}

	func testFailedWeatherSearchByZipCode() {
		givenCurrentForecastSearchWillFail(forInvalidZip)
		service.getWeatherByZipcode(
			zipCode: invalidZip,
			completion: assertCallbackNotInvoked,
			failure: assertFailureCallbackInvoked
		)
		failIfNeitherCallbackInvoked()
	}

	func testFailedWeatherSearchByLocation() {
		givenCurrentForecastSearchWillFail(forInvalidCoordinates)
		service.getWeatherByLocation(location: invalidCoordinates,
		                             completion: assertCallbackNotInvoked,
		                             failure: assertFailureCallbackInvoked
		)
		failIfNeitherCallbackInvoked()
	}

	func givenCurrentForecastSearchWillSucceed(_ params: [String:String]) {
		stubHttpRequest(
			params,
			path: "/data/2.5/weather",
			responseCode: 200,
			responseFile: "CurrentWeather.json"
		)
	}

	func givenHourlyForecastSearchWillSucceed(_ params: [String:String]) {
		stubHttpRequest(
			params,
			path: "/data/2.5/forecast",
			responseCode: 200,
			responseFile: "HourlyForecast.json"
		)
	}

	func givenDailyForecastSearchWillSucceed(_ params: [String:String]) {
		stubHttpRequest(
			params,
			path: "/data/2.5/forecast/daily",
			responseCode: 200,
			responseFile: "DailyForecast.json"
		)
	}

	func givenCurrentForecastSearchWillFail(_ params: [String: String]) {
		stubHttpRequest(
			params,
			path: "/data/2.5/weather",
			responseCode: 400,
			responseFile: "CurrentWeather.json"
		)
	}

	func stubHttpRequest(
			_ params: [String:String],
			path: String,
			responseCode: Int32,
			responseFile: String) {
		var queryParams = params
		queryParams["APPID"] = "95d190a434083879a6398aafd54d9e73"
		stub(condition: isHost("api.openweathermap.org")
			&& containsQueryParams(queryParams)
			&& isPath(path)) { _ in
				return OHHTTPStubsResponse(
					fileAtPath: OHPathForFile(responseFile, type(of: self))!,
					statusCode: responseCode,
					headers: ["Content-Type": "application/json"]
				)
		}
	}

	func failIfNeitherCallbackInvoked() {
		waitForExpectations(timeout: 1) { error in
			if let error = error {
				XCTFail("waitForExpectationsWithTimeout errored: \(error)")
			}
		}
	}

	func assertCurrentWeather(response: CurrentWeatherResponse) {
		XCTAssertEqual(testData.expectedWeatherResponse, response)
		self.expect?.fulfill()
	}

	func assertHourlyForecast(response: [HourlyForecastResponse]) {
		XCTAssertEqual(testData.expectedHourlyForecast, response)
		self.expect?.fulfill()
	}

	func assertDailyForecast(response: [DailyForecastResponse]) {
		XCTAssertEqual(testData.expectedDailyForecast, response)
		self.expect?.fulfill()
	}

	func assertDidNotFail(error: Error) {
		XCTFail("should not have failed")
		self.expect?.fulfill()
	}

	func assertFailureCallbackInvoked(error: Error) {
		XCTAssertTrue(true)
		self.expect?.fulfill()
	}

	func assertCallbackNotInvoked(_ response: CurrentWeatherResponse) {
		XCTFail("should not have been invoked")
		self.expect?.fulfill()
	}

	let forValidCity = ["q": "Hillsboro"]
	let forValidCityId = ["id": "5731371"]
	let forValidZip = ["zip": "97124"]
	let forValidCoordinates = ["lat": "45.52", "lon": "-122.99"]

	let forInvalidCity = ["q": "Bad City Name"]
	let forInvalidCityId = ["id": "-1"]
	let forInvalidZip = ["zip": "-99999"]
	let forInvalidCoordinates = ["lat": "0.0", "lon": "0.0"]

	let validCity = "Hillsboro"
	let validCityId = 5731371
	let validZip = 97124
	let validCoordinates = CLLocation(latitude: 45.52, longitude: -122.99)

	let invalidCity = "Bad City Name"
	let invalidCityId = -1
	let invalidZip = -99999
	let invalidCoordinates = CLLocation(latitude: 0.0, longitude: 0.0)

	let testData = TestData()
}
