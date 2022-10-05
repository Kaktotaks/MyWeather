//
//  Constants.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 27.09.2022.
//

import UIKit

enum Constants {
    static let apiKey = "8c898ee6ea2489277441ec97c87e467d"

    static let apiCityName = "http://api.openweathermap.org/geo/1.0/reverse?lat=51.5098&lon=-0.1180&limit=5&appid={API key}"

    enum Fonts {
        static let timeMinFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let smallFont = UIFont.systemFont(ofSize: 18, weight: .regular)
        static let mediumFont = UIFont.systemFont(ofSize: 22, weight: .medium)
        static let largeFont = UIFont.systemFont(ofSize: 26, weight: .bold)
    }

    enum DateFormats {
        static let hour = "HH"
        static let day = "EEEE"
        static let date = "MMM d"
        static let hourMinute = "HH:mm"
    }
}
