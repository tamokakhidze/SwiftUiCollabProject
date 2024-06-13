//
//  LocationPickerView.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI

struct LocationPickerView: View {
    // MARK: - Properties
    @EnvironmentObject var viewModel: WeatherAppViewModel
    
    var body: some View {
        HStack {
            Menu {
                ForEach(viewModel.favoriteCities, id: \.id) { city in
                    Button(action: {
                        viewModel.fetchWeather(for: city)
                    }) {
                        HStack {
                            Text(city.name)
                            if city.name == viewModel.cityName {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
                NavigationLink(destination: SearchLocationView()) {
                    HStack {
                        Text("Add new location")
                        Image(systemName: "location.fill")
                    }
                }
                
            } label: {
                HStack {
                    Image(.locationPinIcon)
                        .renderingMode(.template)
                        .foregroundColor(.secondaryText)
                    
                    Text(viewModel.cityName)
                        .foregroundColor(.secondaryText)
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    
                    Image(.arrowDown)
                        .renderingMode(.template)
                        .foregroundColor(.secondaryText)
                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 5, trailing: 15))
                .background(.ultraThinMaterial)
                .cornerRadius(50, corners: [.topLeft, .bottomLeft])
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
