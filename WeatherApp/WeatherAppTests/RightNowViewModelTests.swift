import XCTest
import CoreLocation
import MapKit
import Contacts
@testable import WeatherApp

class RightNowViewModelTests: XCTestCase {

	private var weatherBuilder: CurrentWeatherResponseBuilder = CurrentWeatherResponseBuilder()
	private var viewModel: RightNowViewModel?

    override func setUp() {
        super.setUp()
		weatherBuilder = CurrentWeatherResponseBuilder()
		viewModel = nil
    }

    func testShouldPickFirstWeatherCondition() {
		let givenWeather = weatherBuilder.withConditions(WeatherCondition.Clear, WeatherCondition.Rainy).build()
		whenViewModelBuilt(givenWeather)
		XCTAssertEqual(viewModel?.weather, WeatherCondition.Clear.description)
    }

	func testShouldHandleNoWeatherConditions() {
		let givenWeather = weatherBuilder.withConditions().build()
		whenViewModelBuilt(givenWeather)
		XCTAssertEqual(viewModel?.weather, "")
	}

	func testShouldFormatForecastUpdatedTimestamp() {
		let givenWeather = weatherBuilder.withLastUpdatedTime(lastUpdatedUtc).build()
		whenViewModelBuilt(givenWeather)
		XCTAssertEqual(viewModel?.lastUpdated, lastUpdatedStringPST)
	}

	func testShouldDisplayLastUpdatedTimestampInSpecifiedTimeZone() {
		let givenWeather = weatherBuilder.withLastUpdatedTime(lastUpdatedUtc).build()
		whenViewModelBuilt(givenWeather, timeZone: centralEuropeanSummerTime)
		XCTAssertEqual(viewModel?.lastUpdated, lastUpdatedStringCEST)
	}

	func testShouldFormatTemperature() {
		let weather = weatherBuilder.withTemperature(96.4, .fahrenheit).build()
		whenViewModelBuilt(weather)
		XCTAssertEqual(viewModel?.temperature, "96°")
	}

	func testShouldAdaptDifferentTemperatureUnits() {
		let weather = weatherBuilder.withTemperature(5.8, .celsius).build()
		whenViewModelBuilt(weather)
		XCTAssertEqual(viewModel?.temperature, "42°")
	}

	func testShouldUseLocationFromAPIWhenGeolocationNotFound() {
		let weather = weatherBuilder.withLocation(ForecastLocation.Hillsboro).build()
		whenViewModelBuilt(weather, geoLocation: nil)
		XCTAssertEqual(viewModel?.city, "Hillsboro")
		XCTAssertEqual(viewModel?.country, "US")
	}

	func testShouldUseGeoLocationWhenAvailable() {
		let weather = weatherBuilder.withLocation(ForecastLocation.Hillsboro).build()
		let placemark = buildPlacemark(locale: "Hillsboro", adminArea: "OR", country: "United States")
		whenViewModelBuilt(weather, geoLocation: placemark)
		XCTAssertEqual(viewModel?.city, "Hillsboro, OR")
		XCTAssertEqual(viewModel?.country, "United States")
	}

	func testShouldNotRepeatLocationNamesWhenTheLocalityAndAdminAreaAreIdentical() {
		let weather = weatherBuilder.withLocation(ForecastLocation.Hillsboro).build()
		let placemark = buildPlacemark(locale: "Hillsboro", adminArea: "Hillsboro", country: "United States")
		whenViewModelBuilt(weather, geoLocation: placemark)
		XCTAssertEqual(viewModel?.city, "Hillsboro")
		XCTAssertEqual(viewModel?.country, "United States")
	}

	private func whenViewModelBuilt(
							_ forecast: CurrentWeatherResponse,
							timeZone: TimeZone? = nil,
							geoLocation: CLPlacemark? = nil) {
		viewModel = RightNowViewModel(forecast: forecast, timeZone: (timeZone ?? pacificStandardTime)!, location: geoLocation)
	}

	private func buildPlacemark(locale: String, adminArea: String, country: String) -> MKPlacemark {
		return MKPlacemark(
			coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
			addressDictionary: [
				CNPostalAddressCityKey: locale,
				CNPostalAddressStateKey: adminArea,
				CNPostalAddressCountryKey: country
			])
	}

	private let lastUpdatedUtc = Date(timeIntervalSince1970: 1506138960)
	private let lastUpdatedStringPST = "September 22, 8:56 PM"
	private let lastUpdatedStringCEST = "September 23, 5:56 AM"

	private let pacificStandardTime = TimeZone(abbreviation: "PST")
	private let centralEuropeanSummerTime = TimeZone(abbreviation: "CEST")

	let testData = TestData()
}
