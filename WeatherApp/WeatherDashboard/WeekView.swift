// WeekView.swift
// WeatherApp
// Created by Tamuna Kakhidze on 11.06.24.

import SwiftUI

struct WeekView: View {
    // MARK: - Properties
    @EnvironmentObject var viewModel: WeatherAppViewModel
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            weatherContent
                .padding(.horizontal)
                .padding(EdgeInsets(top: 28, leading: 0, bottom: 28, trailing: 0))
                .background(.ultraThinMaterial)
                .cornerRadius(20, corners: [.topLeft, .bottomLeft, .topRight, .bottomRight])
        }
    }
    
    // MARK: - Weather Content
    private var weatherContent: some View {
        VStack {
            ForEach(viewModel.dailyWeather) { daily in
                dailyWeatherRow(for: daily)
            }
        }
    }
    
    // MARK: - Daily Weather Row
    private func dailyWeatherRow(for daily: DailyWeather) -> some View {
        HStack {
            dayLabel(for: daily)
            
            Spacer()
            
            weatherIcon(for: daily)
            
            temperatureView(for: daily.maxTemp)
            
            minTemperatureView(for: daily.minTemp)
        }
        .padding()
        .frame(height: 50)
    }
    
    // MARK: - Day Label
    private func dayLabel(for daily: DailyWeather) -> some View {
        Text(TimeFormat.weekdayString(from: daily.date))
            .frame(height: 22, alignment: .leading)
            .font(.system(size: 18))
            .fontWeight(.bold)
            .foregroundStyle(.white)
    }
    
    // MARK: - Weather Icon
    private func weatherIcon(for daily: DailyWeather) -> some View {
        Group {
            if let url = viewModel.getIconURL(for: daily.icon) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "cloud.fill")
                }
                .frame(width: 50, height: 50)
            }
        }
    }
    
    // MARK: - Temperature View
    private func temperatureView(for temperature: Double) -> some View {
        VStack {
            HStack(alignment: .top, spacing: 0) {
                Text(" \(temperature - 273.15, specifier: "%.0f")")
                    .frame(width: 50, alignment: .trailing)
                    .font(.system(size: 18))
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
                
                Text("°C")
                    .font(.system(size: 10))
                    .foregroundStyle(.white)
            }
        }
    }
    
    // MARK: - Min Temperature View
    private func minTemperatureView(for temperature: Double) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(" \(temperature - 273.15, specifier: "%.0f")")
                .frame(width: 50, alignment: .trailing)
                .font(.system(size: 18))
                .fontWeight(.regular)
            
            Text("°C")
                .font(.system(size: 10))
        }
        .frame(height: 12)
        .foregroundStyle(.secondary)
    }
}

#Preview {
    WeekView()
        .environmentObject(WeatherAppViewModel())
}
