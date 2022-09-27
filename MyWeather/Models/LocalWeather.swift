
import Foundation

struct LocalWeather: Codable {
	let id: Int?
	let main: String?
	let description: String?
	let icon: String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case main = "main"
		case description = "description"
		case icon = "icon"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		main = try values.decodeIfPresent(String.self, forKey: .main)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
	}

}
