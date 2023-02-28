//
//  Constants.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 27.09.2022.
//

import UIKit

enum Constants {
    static let apiKey = "8c898ee6ea2489277441ec97c87e467d"
    
    static let tapAndHoldDescription = "Tap and hold directly on the map to choose location"

    enum Fonts {
        static let timeMinFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let smallFont = UIFont.systemFont(ofSize: 18, weight: .regular)
        static let mediumFont = UIFont.systemFont(ofSize: 22, weight: .medium)
        static let largeFont = UIFont.systemFont(ofSize: 26, weight: .bold)
    }

    enum BackgroundsColors {
        static let lightBlue = UIColor(red: 181/255, green: 213/255, blue: 248/255, alpha: 0.6)
    }

    enum DateFormats {
        static let hour = "HH"
        static let day = "EEEE"
        static let date = "MMM d"
        static let hourMinute = "HH:mm"
    }
}
