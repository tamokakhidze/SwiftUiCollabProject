//
//  ContentView.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    PickerView(
                        viewModel: viewModel
                    )
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
