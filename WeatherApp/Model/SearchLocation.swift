//
//  SearchLocation.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import Foundation

struct SearchLocation: Identifiable, Codable {
    var id: String { name }
    let name: String
    let country: String
}

struct LocationCardModel: Identifiable, Codable {
    var id = UUID()
    let name: String
    let description: String
    let temperature: Int
    let icon: String
}
