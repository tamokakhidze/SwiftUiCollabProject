// WeekView.swift
// WeatherApp
// Created by Tamuna Kakhidze on 11.06.24.

import SwiftUI

struct WeekView: View {
    // MARK: - Properties
    @EnvironmentObject var viewModel: WeatherViewModel
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dailyWeather) { daily in
                    HStack {
                        Text(TimeFormat.weekdayString(from: daily.date))
                            .frame(width: 100, height: 22, alignment: .leading)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        if let url = viewModel.getIconURL(for: daily.icon) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Image(systemName: "cloud.fill")
                            }
                            .frame(width: 50, height: 50)
                        }
                        
                        Spacer()
                        
                        VStack {
                            HStack(alignment: .top, spacing: 0) {
                                Text(" \(daily.maxTemp - 273.15, specifier: "%.0f")")
                                    .frame(width: 50, alignment: .trailing)
                                    .font(.system(size: 18))
                                    .fontWeight(.regular)
                                    .foregroundStyle(.white)
                                
                                Text("°C")
                                    .font(.system(size: 10))
                                
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        HStack(alignment: .top, spacing: 0) {
                            Text(" \(daily.minTemp - 273.15, specifier: "%.0f")")
                                .frame(width: 50, alignment: .trailing)
                                .font(.system(size: 18))
                                .fontWeight(.regular)
                            
                            Text("°C")
                                .font(.system(size: 10))
                        }
                        .frame(height: 12)
                        .foregroundStyle(.secondary)
                        
                    }
                    .padding()
                    .frame(height: 50)
                }
                
            }
            .padding(.horizontal)
            .padding(EdgeInsets(top: 28, leading: 0, bottom: 28, trailing: 0))
            .background(.ultraThinMaterial)
            .cornerRadius(20, corners: [.topLeft, .bottomLeft, .topRight, .bottomRight])
        }
    }
}








