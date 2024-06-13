//
//  PrecipitationsView.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI

struct PrecipitationsView: View {
    // MARK: - Properties
    @EnvironmentObject var viewModel: WeatherViewModel
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 5) {
                    Text("\(kelvinToCelsius(viewModel.dailyWeather.first?.averageTemp ?? 0.0))°")
                        .font(.system(size: 64, weight: .bold))
                    Text("Precipitations")
                        .font(.title2)
                    Text("Max: \(kelvinToCelsius(viewModel.dailyWeather.first?.maxTemp ?? 0.0))° Min: \(kelvinToCelsius(viewModel.dailyWeather.first?.minTemp ?? 0.0))°")
                        .font(.title3)
                }
                .padding(.bottom, 5)
                .padding(.top, 5)
                Spacer()
            }
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .padding()
            .foregroundStyle(.secondaryText)

            
            HStack{
                HStack {
                    Image(systemName: "cloud.drizzle")
                        .renderingMode(.template)
                    
                    Text("18 %")
                }
                Spacer()
                HStack {
                    Image(systemName: "drop.fill")
                        .renderingMode(.template)
                    
                    Text("\(Int(viewModel.dailyWeather.first?.averageHumidity ?? 0)) %")
                }
                Spacer()
                HStack {
                    Image(systemName: "wind")
                        .renderingMode(.template)
                    
                    Text("\(String(format: "%.1f", viewModel.dailyWeather.first?.averageWindSpeed ?? 0.0)) km/h")
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .foregroundStyle(.secondaryText)
            .padding()
            
        }
    }
    
    // MARK: - Calculate Celsius
    func kelvinToCelsius(_ kelvin: Double) -> Int {
        return Int(kelvin - 273.15)
    }
}

