import Foundation

struct Daily: Codable {
	let dt: Int?
	let sunrise: Int?
	let sunset: Int?
	let moonrise: Int?
	let moonset: Int?
	let moonPhase: Double?
	let temp: Temp?
	let feelsLike: FeelsLike?
	let pressure: Int?
	let humidity: Int?
	let dewPoint: Double?
	let windSpeed: Double?
	let windDeg: Int?
	let windGust: Double?
	let weather: [LocalWeather]?
	let clouds: Int?
//	let pop: Int?
	let uvi: Double?

	enum CodingKeys: String, CodingKey {

		case dt = "dt"
		case sunrise = "sunrise"
		case sunset = "sunset"
		case moonrise = "moonrise"
		case moonset = "moonset"
		case moonPhase = "moon_phase"
		case temp = "temp"
		case feelsLike = "feels_like"
		case pressure = "pressure"
		case humidity = "humidity"
		case dewPoint = "dew_point"
		case windSpeed = "wind_speed"
		case windDeg = "wind_deg"
		case windGust = "wind_gust"
		case weather = "weather"
		case clouds = "clouds"
//		case pop = "pop"
		case uvi = "uvi"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dt = try values.decodeIfPresent(Int.self, forKey: .dt)
		sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise)
		sunset = try values.decodeIfPresent(Int.self, forKey: .sunset)
		moonrise = try values.decodeIfPresent(Int.self, forKey: .moonrise)
		moonset = try values.decodeIfPresent(Int.self, forKey: .moonset)
		moonPhase = try values.decodeIfPresent(Double.self, forKey: .moonPhase)
		temp = try values.decodeIfPresent(Temp.self, forKey: .temp)
		feelsLike = try values.decodeIfPresent(FeelsLike.self, forKey: .feelsLike)
		pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
		humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
		dewPoint = try values.decodeIfPresent(Double.self, forKey: .dewPoint)
		windSpeed = try values.decodeIfPresent(Double.self, forKey: .windSpeed)
		windDeg = try values.decodeIfPresent(Int.self, forKey: .windDeg)
		windGust = try values.decodeIfPresent(Double.self, forKey: .windGust)
		weather = try values.decodeIfPresent([LocalWeather].self, forKey: .weather)
		clouds = try values.decodeIfPresent(Int.self, forKey: .clouds)
//		pop = try values.decodeIfPresent(Int.self, forKey: .pop)
		uvi = try values.decodeIfPresent(Double.self, forKey: .uvi)
	}

}
