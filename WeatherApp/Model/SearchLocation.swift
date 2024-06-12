//
//  SearchLocation.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import Foundation

struct City: Identifiable, Codable {
    var id: String { name }
    let name: String
    let country: String
}

struct LocationCardModel: Identifiable {
    var id = UUID()
    let name: String
    let description: String
    let temperature: Int
    let icon: String
}
