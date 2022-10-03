import Foundation

struct Hourly: Codable {
	let dt: Int?
	let temp: Double?
    let feelsLike: Double?
	let pressure: Int?
	let humidity: Int?
	let dewPoint: Double?
	let uvi: Double?
	let clouds: Int?
	let visibility: Int?
	let windSpeed: Double?
	let windDeg: Int?
	let windGust: Double?
	let weather: [LocalWeather]?
//	let pop: Int?

	enum CodingKeys: String, CodingKey {

		case dt = "dt"
		case temp = "temp"
		case feelsLike = "feels_like"
		case pressure = "pressure"
		case humidity = "humidity"
		case dewPoint = "dew_point"
		case uvi = "uvi"
		case clouds = "clouds"
		case visibility = "visibility"
		case windSpeed = "wind_speed"
		case windDeg = "wind_deg"
		case windGust = "wind_gust"
		case weather = "weather"
//		case pop = "pop"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dt = try values.decodeIfPresent(Int.self, forKey: .dt)
		temp = try values.decodeIfPresent(Double.self, forKey: .temp)
		feelsLike = try values.decodeIfPresent(Double.self, forKey: .feelsLike)
		pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
		humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
		dewPoint = try values.decodeIfPresent(Double.self, forKey: .dewPoint)
		uvi = try values.decodeIfPresent(Double.self, forKey: .uvi)
		clouds = try values.decodeIfPresent(Int.self, forKey: .clouds)
		visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
		windSpeed = try values.decodeIfPresent(Double.self, forKey: .windSpeed)
		windDeg = try values.decodeIfPresent(Int.self, forKey: .windDeg)
		windGust = try values.decodeIfPresent(Double.self, forKey: .windGust)
		weather = try values.decodeIfPresent([LocalWeather].self, forKey: .weather)
//		pop = try values.decodeIfPresent(Int.self, forKey: .pop)
	}

}
