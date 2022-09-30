import Foundation

struct Current: Codable {
	let dt: Int?
	let sunrise: Int?
	let sunset: Int?
	let temp: Double?
	let feelsLike: Double?
	let pressure: Int?
	let humidity: Int?
	let dewPoint: Double?
	let uvi: Double?
	let clouds: Int?
	let visibility: Int?
//	let windSpeed: Int?
	let windDeg: Int?
	let weather: [LocalWeather]?

	enum CodingKeys: String, CodingKey {

		case dt = "dt"
		case sunrise = "sunrise"
		case sunset = "sunset"
		case temp = "temp"
		case feelsLike = "feels_like"
		case pressure = "pressure"
		case humidity = "humidity"
		case dewPoint = "dew_point"
		case uvi = "uvi"
		case clouds = "clouds"
		case visibility = "visibility"
//		case windSpeed = "wind_speed"
		case windDeg = "wind_deg"
		case weather = "weather"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dt = try values.decodeIfPresent(Int.self, forKey: .dt)
		sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise)
		sunset = try values.decodeIfPresent(Int.self, forKey: .sunset)
		temp = try values.decodeIfPresent(Double.self, forKey: .temp)
		feelsLike = try values.decodeIfPresent(Double.self, forKey: .feelsLike)
		pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
		humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
        dewPoint = try values.decodeIfPresent(Double.self, forKey: .dewPoint)
		uvi = try values.decodeIfPresent(Double.self, forKey: .uvi)
		clouds = try values.decodeIfPresent(Int.self, forKey: .clouds)
		visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
//		windSpeed = try values.decodeIfPresent(Int.self, forKey: .windSpeed)
        windDeg = try values.decodeIfPresent(Int.self, forKey: .windDeg)
		weather = try values.decodeIfPresent([LocalWeather].self, forKey: .weather)
	}
}
