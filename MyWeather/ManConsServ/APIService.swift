//
//  APIService.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 09.10.2022.
//

import Foundation

class APIService {
    static var shared = APIService()
    private init() {}

    private let session = URLSession(configuration: .default)

    // MARK: - Get data for searchVC
    func getLocationsByName(for query: String, completion: @escaping([WeahterSearchResponse]?, Error?) -> Void) {
        guard
            let formatedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {
            return
        }

        guard
            let searchURL = URL(
                string: "http://api.openweathermap.org/geo/1.0/direct?q=\(formatedQuery)&limit=5&appid=\(Constants.apiKey)"
            )
        else {
            debugPrint("Invalid geoURL ❌")
            return
        }

        URLSession.shared.dataTask(with: searchURL, completionHandler: { data, response, error in
            // Validation
            guard let data = data, error == nil else {
                debugPrint("Invalid searchURL ❌ - \(error)")
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

    // MARK: - Get data for header's cityName label.
    func getGeoData(lat: Double, lon: Double, completion: @escaping([WeatherGeoResponse]?, Error?) -> Void) {
        guard
            let geoURL = URL(
                string: "http://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(lon)&limit=5&appid=\(Constants.apiKey)"
            )
        else {
            debugPrint("Invalid geoURL ❌")
            return
        }

        URLSession.shared.dataTask(with: geoURL, completionHandler: { data, response, error in
            // Validation
            guard let data = data, error == nil else {
                debugPrint("Something went wrong ❌ - \(error)")
                return
            }

            // Convert data to model / some object
            var json: [WeatherGeoResponse]?

            do {
                json = try JSONDecoder().decode([WeatherGeoResponse].self, from: data)
                completion(json, nil)
            } catch {
                debugPrint("Error: \(error) while decoding some gep data ❌ ")
            }
        }).resume()
    }

    // MARK: - Get data for current + hourly + daily objects
    func getWeatherData(lat: Double, lon: Double, completion: @escaping(WeatherResponse?, Error?) -> Void) {
        guard
            let dataURL = URL(
                string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely,alerts&appid=\(Constants.apiKey)"
            )
        else {
            debugPrint("Invalid dataURL ❌")
            return
        }

        URLSession.shared.dataTask(with: dataURL, completionHandler: { data, response, error in
            // Validation
            guard let data = data, error == nil else {
                debugPrint("Something went wrong ❌ - \(error)")
                return
            }

            // Convert data to model / some object
            var json: WeatherResponse?

            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(json, nil)
            } catch {
                debugPrint("Error: \(error) while decoding some gep data ❌ ")
            }
        }).resume()
    }
}
