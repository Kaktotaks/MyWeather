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

        URLSession.shared.dataTask(with: searchURL, completionHandler: { data, response, error in
            // Validation
            guard let data = data, error == nil else {
                debugPrint("Something went wrong ❌")
                return
            }
            
            // Convert data to model / some object
            var json: [WeahterSearchResponse]?

            do {
                json = try JSONDecoder().decode([WeahterSearchResponse].self, from: data)
                completion(json, nil)
            } catch {
                debugPrint("Error: \(error) while decoding some searching data ❌ ")
            }

        }).resume()
    }
}
