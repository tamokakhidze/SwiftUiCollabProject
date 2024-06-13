//
//  SearchLocationView.swift
//  WeatherApp
//
//  Created by Tamuna Kakhidze on 11.06.24.
//

import SwiftUI

struct SearchLocationView: View {
    @State private var cityName: String = ""
    @State private var searchPerformed: Bool = false
    @State private var searchCompleted: Bool = false
    @EnvironmentObject var viewModel: WeatherAppViewModel
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Body View
    var body: some View {
        VStack(alignment: .leading) {
            headerView
            searchBarView
            contentView
            Spacer()
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .onAppear {
            resetSearch()
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        Text("Locations")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .padding(.leading, 16)
            .padding(.top, 16)
    }

    // MARK: - Search Bar View
    private var searchBarView: some View {
        HStack {
            searchTextField
            if !cityName.isEmpty {
                cancelButton
            }
        }
        .padding(.bottom, 10)
    }

    private var searchTextField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .padding(.leading, 8)
            TextField("Search", text: $cityName, onCommit: {
                performSearch()
            })
            .padding(8)
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.leading, 16)
        .padding(.trailing, cityName.isEmpty ? 16 : 8)
    }

    private var cancelButton: some View {
        Button(action: {
            resetSearch()
        }) {
            Text("Cancel")
                .foregroundColor(.blue)
        }
        .padding(.trailing, 16)
    }

    // MARK: - Content View
    private var contentView: some View {
        Group {
            if searchPerformed {
                searchResultsView
            } else {
                recentLocationsView
            }
        }
    }

    // MARK: - Search Results View
    private var searchResultsView: some View {
        Group {
            if viewModel.cities.isEmpty {
                noCitiesView
            } else {
                citiesListView
            }
        }
    }

    private var noCitiesView: some View {
        Group {
            if searchCompleted {
                Text("No cities found")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }

    private var citiesListView: some View {
        List(viewModel.cities) { city in
            Button(action: {
                if !viewModel.favoriteCities.contains(where: { $0.name == city.name }) {
                    viewModel.fetchWeather(for: city)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("\(city.name), \(city.country)")
                    .padding(.leading, 2)
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            searchCompleted = true
        }
    }

    // MARK: - Recent Locations View
    private var recentLocationsView: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(viewModel.locationCards) { card in
                    LocationCard(locationName: card.name, shortDescription: card.description, celsius: card.temperature)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.top, 10)
        }
    }

    // MARK: - Helper Functions
    private func performSearch() {
        viewModel.fetchCities(name: cityName)
        searchPerformed = true
        searchCompleted = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            searchCompleted = true
        }
    }

    private func resetSearch() {
        cityName = ""
        searchPerformed = false
        searchCompleted = false
        viewModel.cities.removeAll()
    }
}

#Preview {
    NavigationView {
        SearchLocationView()
            .environmentObject(WeatherAppViewModel())
    }
}
