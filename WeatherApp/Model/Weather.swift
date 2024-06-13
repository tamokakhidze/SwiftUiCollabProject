//
//  Weather.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import Foundation

struct Weather: Codable {
    let main: Main
    let weather: [WeatherInfo]
    let wind: Wind
    let dt: Int
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(dt))
    }
}

struct DailyWeather: Identifiable {
    let id = UUID()
    let date: String
    let averageTemp: Double
    let minTemp: Double
    let maxTemp: Double
    let averageHumidity: Double
    let averageWindSpeed: Double
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
}

struct Wind: Codable {
    let speed: Double
}

struct WeatherInfo: Codable {
    let description: String
    let icon: String
    let main: String
}

struct WeatherResponse: Codable {
    let list: [Weather]
}
