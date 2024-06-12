//
//  Weather.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import Foundation

struct DailyWeather: Identifiable {
    let id = UUID()
    let date: String
    let averageTemp: Double
    let description: String
    let icon: String
}

struct WeatherResponse: Codable {
    let list: [Weather]
}

struct Weather: Codable {
    let main: Main
    let weather: [WeatherInfo]
    let dt: Int
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(dt))
    }
}

struct Main: Codable {
    let temp: Double
}

struct WeatherInfo: Codable {
    let description: String
    let icon: String
}
