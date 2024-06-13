// WeekView.swift
// WeatherApp
// Created by Tamuna Kakhidze on 11.06.24.

import SwiftUI

struct WeekView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        
        ScrollView {
            VStack {
                ForEach(viewModel.dailyWeather, id: \.id) { daily in
                    HStack {
                        Text(TimeFormat.weekdayString(from: daily.date))
                            .frame(width: 100, alignment: .leading)
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
                            Text(" \(daily.maxTemp - 273.15, specifier: "%.0f")°C")
                                .frame(width: 50, alignment: .trailing)
                        }
                        Spacer()
                        Text(" \(daily.minTemp - 273.15, specifier: "%.0f")°C")
                            .frame(width: 50, alignment: .trailing)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                }
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    WeekView()
        .environmentObject(WeatherViewModel())
}

import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}







