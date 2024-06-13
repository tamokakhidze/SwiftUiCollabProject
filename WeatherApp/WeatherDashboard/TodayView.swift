//
//  TodayView.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI

struct TodayView: View {
    @State private var selectedIndex: Int? = 0
    @EnvironmentObject var viewModel: WeatherAppViewModel
    
    var currentDateFormatted: String {
        shortDateFormatter.string(from: Date())
    }
    
    // MARK: - Header View
    var headerView: some View {
        HStack {
            Text("Today")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: -2, y: 3)
            Spacer()
            Text(currentDateFormatted)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: -2, y: 3)
        }
        .padding([.leading, .trailing, .top], 12)
    }
    
    // MARK: - Weather Cards
    var weatherCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(Array(viewModel.weather.enumerated()), id: \.offset) { index, data in
                    WeatherCard(data: data, isSelected: index == selectedIndex, viewModel: viewModel)
                        .onTapGesture {
                            selectedIndex = index
                        }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
    }
    
    // MARK: - Body View
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            weatherCards
        }
        .frame(height: 217)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .padding()
    }
}

// MARK: - WeatherCard View
struct WeatherCard: View {
    let data: Weather
    let isSelected: Bool
    @ObservedObject var viewModel: WeatherAppViewModel
    
    var selectedGradient: some View {
        RadialGradient(
            gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.0)]),
            center: .center,
            startRadius: 0,
            endRadius: 70
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(1)
    }
    
    var temperatureText: some View {
        Text("\(data.main.temp - 273.15, specifier: "%.0f")°C")
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: -2, y: 3)
            .padding(.top, 16)
    }
    
    var weatherIcon: some View {
        Group {
            if let iconURL = viewModel.getIconURL(for: data.weather.first?.icon ?? "") {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45)
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }
    
    var timeText: some View {
        Text(TimeFormat.timeFormatter.string(from: data.date))
            .font(.system(size: 18, weight: .regular))
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: -2, y: 3)
            .padding(.bottom, 16)
    }
    
    var body: some View {
        ZStack {
            if isSelected {
                selectedGradient
            }
            VStack(spacing: 16) {
                temperatureText
                weatherIcon
                timeText
            }
            .frame(width: 70, height: 155)
            .background(Color.white.opacity(isSelected ? 0.2 : 0.0))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
        }
    }
}

#Preview {
    TodayView()
        .environmentObject(WeatherAppViewModel())
}

// MARK: - Date Formatter
let shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM, dd"
    return formatter
}()
