//
//  LocationCard.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI

struct LocationCard: View {
    var locationName: String
    var shortDescription: String
    var celsius: Int
    
    var body: some View {
        HStack {
            VStack(spacing: 14) {
                Text("\(locationName)")
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(shortDescription)")
                    .font(.system(size: 10))
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Text("\(celsius)°")
                .font(.system(size: 53))
                .foregroundStyle(.white)
            
        }
        .frame(width: 335, height: 77)
        .padding(EdgeInsets(top: 11, leading: 15, bottom: 11, trailing: 15))
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.locationCard1, .locationCard2]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(16)
        
    }
}

#Preview {
    LocationCard(locationName: "T'bilisi", shortDescription: "Cloudy", celsius: 22)
}

