//
//  NetworkingService.swift
//  WeatherApp
//
//  Created by Zuka Papuashvili on 12.06.24.
//

import Foundation

class NetworkingService {
    
    public static let shared = NetworkingService()
    
    private init() { }
    
    func fetchData<T: Decodable>(from url: URL, headers: [String: String] = [:], completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 1, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}


