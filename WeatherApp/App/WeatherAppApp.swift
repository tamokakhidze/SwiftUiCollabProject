//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI
 
@main
struct WeatherAppApp: App {
    @StateObject private var viewModel = WeatherAppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
