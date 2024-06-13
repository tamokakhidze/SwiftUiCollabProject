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
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5 / 9
    }
 
    static func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return (celsius * 9 / 5) + 32
    }
 
    static func formatTemperature(_ temperature: Double, unit: TemperatureUnit) -> String {
        switch unit {
        case .celsius:
            return String(format: "%.0f°C", temperature)
        case .fahrenheit:
            return String(format: "%.0f°F", temperature)
        }
    }
    
    static func weekdayString(from dateString: String) -> String {
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
 
enum TemperatureUnit {
    case celsius
    case fahrenheit
}

