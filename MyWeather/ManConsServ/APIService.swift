//
//  APIService.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 09.10.2022.
//

import Foundation

class APIService {
    static var shared = APIService()
    let session = URLSession(configuration: .default)

    func getLocationsByName(for query: String, completion: @escaping([WeahterSearchResponse]?, Error?) -> Void) {
        guard
            let formatedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {
            return
        }

        guard
            let searchURL = URL(string: "http://api.openweathermap.org/geo/1.0/direct?q=\(formatedQuery)&limit=5&appid=\(Constants.apiKey)")
        else {
            debugPrint("Invalid geoURL ❌")
            return
        }

        let task = session.dataTask(with: searchURL) { data, response, error in
            if let error = error {
                print(error.localizedDescription + "from getLocationsByName task ❌")
                completion(nil, error)
            }

            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(WeahterSearchResponse.self, from: data)
                 //   print(decodedData)
                    completion([decodedData], nil)
                } catch {
                    print(error.localizedDescription + "2 ❌❌" )
                }
            }
        }
        task.resume()
    }
}
