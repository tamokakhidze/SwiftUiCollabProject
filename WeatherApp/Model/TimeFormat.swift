//
//  TimeFormat.swift
//  WeatherApp
//
//  Created by Zuka Papuashvili on 12.06.24.
//

import Foundation

struct TimeFormat {
   static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
