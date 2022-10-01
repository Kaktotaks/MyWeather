//
//  DateFormaterManager.swift
//  MyWeather
//
//  Created by Леонід Шевченко on 01.10.2022.
//

import UIKit

struct DateFormaterManager {
    static let shared = DateFormaterManager()

    private init() { }

    func formatDate(date: Date?, dateFormat: String) -> String {
        guard let inputDate = date else { return "" }

        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: inputDate)
    }

}
