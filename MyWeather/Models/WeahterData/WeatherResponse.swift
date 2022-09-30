import Foundation

struct WeatherResponse: Codable {
	let lat: Double?
	let lon: Double?
	let timezone: String?
	let timezoneOffset: Int?
	let current: Current?
	let hourly: [Hourly]?
	let daily: [Daily]?

	enum CodingKeys: String, CodingKey {

		case lat = "lat"
		case lon = "lon"
		case timezone = "timezone"
		case timezoneOffset = "timezone_offset"
		case current = "current"
		case hourly = "hourly"
		case daily = "daily"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		lat = try values.decodeIfPresent(Double.self, forKey: .lat)
		lon = try values.decodeIfPresent(Double.self, forKey: .lon)
		timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
		timezoneOffset = try values.decodeIfPresent(Int.self, forKey: .timezoneOffset)
		current = try values.decodeIfPresent(Current.self, forKey: .current)
		hourly = try values.decodeIfPresent([Hourly].self, forKey: .hourly)
		daily = try values.decodeIfPresent([Daily].self, forKey: .daily)
	}

}
