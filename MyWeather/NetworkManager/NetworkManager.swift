//
//  NetworkManager.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 23.09.2022.
//

import Foundation
import Alamofire

struct NetworkManager {
    static let shared = NetworkManager()

    // MARK: - Network request for reloading daily weather
    func requestDailyWeather(completion: @escaping(([Daily]) -> ())) {

        let url = "https://api.openweathermap.org/data/3.0/onecall?lat=37.33233141&lon=-122.0312186&units=metric&exclude=minutely,alerts&appid=8c898ee6ea2489277441ec97c87e467d"
        AF.request(url).responseJSON { responce in

            let decoder = JSONDecoder()

            if let data = try? decoder.decode(WeatherResponse.self, from: responce.data ?? Data()) {
//                let daily = data.daily ?? []
//                completion(daily)
            }
        }
    }
}
