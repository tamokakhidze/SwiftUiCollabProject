// WeekView.swift
// WeatherApp
// Created by Tamuna Kakhidze on 11.06.24.

import SwiftUI

struct WeekView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.dailyWeather, id: \.date) { day in
                HStack {
                    Text(day.date)
                        .frame(width: 80, alignment: .leading)
                    Spacer()
                    
                    if let iconURL = viewModel.getIconURL(for: day.icon) {
                        AsyncImage(url: iconURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                    }
                    Spacer(minLength: 70)
                    
                    Text("\(Int(day.averageTemp - 273.15))°")
                        .frame(width: 40, alignment: .trailing)
                    Text("\(Int(day.averageTemp - 273.15))°")
                        .frame(width: 40, alignment: .trailing)
                        .foregroundStyle(.secondaryText)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.vertical, 5)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listRowInsets(EdgeInsets())
        }
        .background(BlurView())
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(viewModel: WeatherViewModel())
    }
}


import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}







