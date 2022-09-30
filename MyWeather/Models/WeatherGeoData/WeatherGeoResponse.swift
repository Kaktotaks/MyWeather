import Foundation

struct WeatherGeoResponse: Codable {
    let name: String?
    var localNames: LocalNames?
    let lat: Double?
    let lon: Double?
    let country: String?
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case localNames = "local_names"
        case lat = "lat"
        case lon = "lon"
        case country = "country"
        case state = "state"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        localNames = try values.decodeIfPresent(LocalNames.self, forKey: .localNames)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lon = try values.decodeIfPresent(Double.self, forKey: .lon)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        state = try values.decodeIfPresent(String.self, forKey: .state)
    }
}
