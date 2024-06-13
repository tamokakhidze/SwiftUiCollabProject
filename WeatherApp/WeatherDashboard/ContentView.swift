//
//  ContentView.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    private var customBackground: AnyView {
        if let weatherMain = viewModel.weather.first?.weather.first?.main.lowercased() {
            switch weatherMain {
            case "clouds":
                return AnyView(CloudyBackground())
            case "rain", "drizzle", "thunderstorm":
                return AnyView(RainyBackground())
            case "snow":
                return AnyView(SnowyBackground())
            default:
                return AnyView(SunnyBackground())
            }
        } else {
            return AnyView(SunnyBackground())
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                customBackground
                
                ScrollView {
                    VStack(spacing: 22) {
                        HStack {
                            Spacer()
                            
                            PickerView(viewModel: _viewModel)
                        }
                        Spacer().frame(height: 68)
                        VStack {
                            PrecipitationsView()
                            
                            WeatherView().padding(2)
                            
                            WeekView()
                                .padding(EdgeInsets(top: 0, leading: 19, bottom: 0, trailing: 19))
                        }
                    }
                }
            }.onAppear {
                print(viewModel.locationCards.description)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WeatherViewModel())
}
