//
//  WeatherAppViewModel.swift
//  WeatherApp
//
//  Created by Zuka Papuashvili on 12.06.24.
//

import Foundation

final class WeatherAppViewModel: ObservableObject {
    // MARK: - Cities Property
    @Published var cities: [SearchLocation] = []
    private let cityApiKey = "S6mPry2Yz9yg/qYd6t3ssA==QV6tAbktzatADr9h"
    
    // MARK: - Weather Properties
    @Published var weather: [Weather] = []
    @Published var dailyWeather: [DailyWeather] = []
    @Published var cityName: String = "Tbilisi"
    @Published var favoriteCities: [SearchLocation] = []
    @Published var locationCards: [LocationCardModel] = []
    private let weatherApiKey = "ebb0b179a69b3593243135c990d01991"
    
    private let userDefaults = UserDefaults.standard
    private let citiesKey = "favoriteCities"
    private let locationCardsKey = "locationCards"
    
    // MARK: - Default Init For First Page
    init() {
        loadFromUserDefaults()
    }
    
    // MARK: - Fetching Cities
    func fetchCities(name: String) {
        let urlString = "https://api.api-ninjas.com/v1/city?name=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&limit=3"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let headers = ["X-Api-Key": cityApiKey]
        NetworkingService.shared.fetchData(from: url, headers: headers) { [weak self] (result: Result<[SearchLocation], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cities):
                    self?.cities = cities
                case .failure(let error):
                    print("Error fetching cities: \(error)")
                }
            }
        }
    }
    
    // MARK: - Fetching Weather With City Name
    func fetchWeather(for city: SearchLocation) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&appid=\(weatherApiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        NetworkingService.shared.fetchData(from: url) { [weak self] (result: Result<WeatherResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    guard let self = self else { return }
                    self.weather = weatherResponse.list
                    self.dailyWeather = self.aggregateWeatherByDay(weatherList: self.weather)
                    self.cityName = city.name
                    self.addLocationCard(for: city, weatherResponse: weatherResponse)
                    if !self.favoriteCities.contains(where: { $0.name == city.name }) {
                        self.favoriteCities.append(city)
                        self.saveToUserDefaults()
                    }
                case .failure(let error):
                    print("Error fetching weather: \(error)")
                }
            }
        }
    }
    
    // MARK: - Transforming Hourly Into Weekly Days
    private func aggregateWeatherByDay(weatherList: [Weather]) -> [DailyWeather] {
        var dailyWeatherDict = [String: [Weather]]()
        
        for weather in weatherList {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateKey = dateFormatter.string(from: weather.date)
            
            if dailyWeatherDict[dateKey] == nil {
                dailyWeatherDict[dateKey] = [Weather]()
            }
            dailyWeatherDict[dateKey]?.append(weather)
        }
        
        var dailyWeatherArray = [DailyWeather]()
        
        for (date, weatherList) in dailyWeatherDict {
            let averageTemp = weatherList.map { $0.main.temp }.reduce(0, +) / Double(weatherList.count)
            let minTemp = weatherList.map { $0.main.temp_min }.min() ?? 0.0
            let maxTemp = weatherList.map { $0.main.temp_max }.max() ?? 0.0
            let averageHumidity = weatherList.map { $0.main.humidity }.reduce(0, +) / Double(weatherList.count)
            let averageWindSpeed = weatherList.map { $0.wind.speed }.reduce(0, +) / Double(weatherList.count)
            let descriptions = weatherList.flatMap { $0.weather.map { $0.description } }
            let mostFrequentDescription = descriptions.mostFrequent()
            
            let dailyWeather = DailyWeather(
                date: date,
                averageTemp: averageTemp,
                minTemp: minTemp,
                maxTemp: maxTemp,
                averageHumidity: averageHumidity,
                averageWindSpeed: averageWindSpeed,
                description: mostFrequentDescription ?? "",
                icon: weatherList.first?.weather.first?.icon ?? ""
            )
            dailyWeatherArray.append(dailyWeather)
        }
        
        dailyWeatherArray.sort { $0.date < $1.date }
        
        return dailyWeatherArray
    }
    
    // MARK: - Adding Location Cards
    private func addLocationCard(for city: SearchLocation, weatherResponse: WeatherResponse) {
        let tempKelvin = weatherResponse.list.first?.main.temp ?? 273.15
        let tempCelsius = tempKelvin - 273.15
        let description = weatherResponse.list.first?.weather.first?.description ?? ""
        let icon = weatherResponse.list.first?.weather.first?.icon ?? ""
        
        if !locationCards.contains(where: { $0.name == city.name }) {
            let locationCard = LocationCardModel(name: city.name, description: description, temperature: Int(tempCelsius), icon: icon)
            locationCards.append(locationCard)
        }
    }
    
    // MARK: - Downloading Icons
    func getIconURL(for icon: String) -> URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
    
    // MARK: - Save Data to UserDefaults
    private func saveToUserDefaults() {
        DispatchQueue.global(qos: .background).async {
            if let encodedCities = try? JSONEncoder().encode(self.favoriteCities) {
                self.userDefaults.set(encodedCities, forKey: self.citiesKey)
                print("Saved favoriteCities to UserDefaults")
            } else {
                print("Failed to encode favoriteCities")
            }
            
            if let encodedLocationCards = try? JSONEncoder().encode(self.locationCards) {
                self.userDefaults.set(encodedLocationCards, forKey: self.locationCardsKey)
                print("Saved locationCards to UserDefaults")
            } else {
                print("Failed to encode locationCards")
            }
        }
    }
    
    // MARK: - Load Data from UserDefaults
    private func loadFromUserDefaults() {
        DispatchQueue.global(qos: .background).async {
            if let savedCitiesData = self.userDefaults.data(forKey: self.citiesKey) {
                do {
                    let savedCities = try JSONDecoder().decode([SearchLocation].self, from: savedCitiesData)
                    DispatchQueue.main.async {
                        self.favoriteCities = savedCities
                        print("Loaded favoriteCities from UserDefaults: \(savedCities)")
                        if self.favoriteCities.isEmpty {
                            let defaultCity = SearchLocation(name: "Tbilisi", country: "GE")
                            self.favoriteCities.append(defaultCity)
                            self.fetchWeather(for: defaultCity)
                            self.saveToUserDefaults()
                        } else if let firstCity = self.favoriteCities.first {
                            self.fetchWeather(for: firstCity)
                        }
                    }
                } catch {
                    print("Failed to decode favoriteCities: \(error)")
                }
            } else {
                print("No favoriteCities data found in UserDefaults")
                DispatchQueue.main.async {
                    let defaultCity = SearchLocation(name: "Tbilisi", country: "GE")
                    self.favoriteCities.append(defaultCity)
                    self.fetchWeather(for: defaultCity)
                    self.saveToUserDefaults()
                }
            }
            
            if let savedLocationCardsData = self.userDefaults.data(forKey: self.locationCardsKey) {
                do {
                    let savedLocationCards = try JSONDecoder().decode([LocationCardModel].self, from: savedLocationCardsData)
                    DispatchQueue.main.async {
                        self.locationCards = savedLocationCards
                        print("Loaded locationCards from UserDefaults: \(savedLocationCards)")
                    }
                } catch {
                    print("Failed to decode locationCards: \(error)")
                }
            } else {
                print("No locationCards data found in UserDefaults")
            }
        }
    }
    
}

// MARK: - Most Frequent Weather In Array
extension Array where Element: Hashable {
    func mostFrequent() -> Element? {
        let counts = self.reduce(into: [:]) { counts, element in counts[element, default: 0] += 1 }
        return counts.max { $0.1 < $1.1 }?.key
    }
}
