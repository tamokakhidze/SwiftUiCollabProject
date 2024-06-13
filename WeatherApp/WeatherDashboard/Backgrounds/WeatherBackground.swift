//
//  WeatherBackground.swift
//  WeatherApp
//
//  Created by ana namgaladze on 13.06.24.
//

import SwiftUI

struct WeatherBackground: View {
    @Environment(\.colorScheme) var colorScheme
    let gradientColors: [Color]
    let lightModeAnimation: () -> AnyView
    let darkModeAnimation: () -> AnyView

    var body: some View {
        ZStack {
            LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            if colorScheme == .dark {
                darkModeAnimation()
            } else {
                lightModeAnimation()
            }
        }
    }
}
