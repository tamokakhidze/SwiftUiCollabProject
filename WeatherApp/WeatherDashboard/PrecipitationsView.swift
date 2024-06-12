//
//  PrecipitationsView.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI

struct PrecipitationsView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 5) {
                    Text("\(kelvinToCelsius(viewModel.dailyWeather.first?.averageTemp ?? 0.0))°")
                        .font(.system(size: 64, weight: .bold))
                    Text("Precipitations")
                        .font(.title2)
                    Text("Max: \(kelvinToCelsius(viewModel.dailyWeather.first?.averageTemp ?? 0.0))° Min: \(kelvinToCelsius(viewModel.dailyWeather.first?.averageTemp ?? 0.0))°")
                        .font(.title3)
                }
                .padding(.bottom, 5)
                .padding(.top, 5)
                Spacer()
            }
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
            

            HStack(spacing: 30) {
                HStack {
                    Image(.drizzlePercentageIcon)
                        .renderingMode(.template)

                    Text("\(viewModel.weather.first?.main.temp ?? 0)")
                }
                Spacer()
                HStack {
                    Image(.humidityIcon)
                        .renderingMode(.template)

                    Text("\(viewModel.weather.first?.main.temp ?? 0)%")
                }
                Spacer()
                HStack {
                    Image(.windIcon)
                        .renderingMode(.template)
                        
                    Text("\(String(format: "%.1f", viewModel.weather.first?.main.temp ?? 0.0)) km/h")
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
            //.foregroundStyle(.white)
            
        }
    }
        func kelvinToCelsius(_ kelvin: Double) -> Int {
        return Int(kelvin - 273.15)
    }
}

#Preview {
    PrecipitationsView(viewModel: WeatherViewModel())
}
