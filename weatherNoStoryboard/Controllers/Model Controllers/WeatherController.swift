//
//  WeatherController.swift
//  weatherNoStoryboard
//
//  Created by Jacob Schvaneveldt on 9/20/21.
//


import Foundation

class WeatherController {
    
    static let shared = WeatherController()
    
    func fetchWeather(searchTerm: String, completion:@escaping(Result<Weather, NetworkError>) -> Void) {
        
        guard let baseURL = weatherStrings.baseURL else {return completion(.failure(.invalidURL))}
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: weatherStrings.apiKeyName, value: weatherStrings.apiKeyValue)
        let searchQuery = URLQueryItem(name: weatherStrings.searchValue, value: searchTerm)
        let daysQuery = URLQueryItem(name: weatherStrings.days, value: "7")
        let aqiQuery = URLQueryItem(name: weatherStrings.aqi, value: "no")
        let alertsQuery = URLQueryItem(name: weatherStrings.alerts, value: "no")
        
        components?.queryItems = [apiQuery, searchQuery, daysQuery, aqiQuery, alertsQuery]
        
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("WEATHER STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let tlo = try JSONDecoder().decode(Weather.self, from: data)
                let numbers = tlo.current
                
                completion(.success(tlo))
            } catch {
                completion(.failure(.thrownError(error)))
            }
            
        }.resume()
        
    }
    
    func fetchForcast(searchTerm: String, completion:@escaping((Result<[_Day], NetworkError>) -> Void)) {
        
        guard let baseURL = weatherStrings.baseURL else {return completion(.failure(.invalidURL))}
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: weatherStrings.apiKeyName, value: weatherStrings.apiKeyValue)
        let searchQuery = URLQueryItem(name: weatherStrings.searchValue, value: searchTerm)
        let daysQuery = URLQueryItem(name: weatherStrings.days, value: "10")
        let aqiQuery = URLQueryItem(name: weatherStrings.aqi, value: "no")
        let alertsQuery = URLQueryItem(name: weatherStrings.alerts, value: "no")
        
        components?.queryItems = [apiQuery, searchQuery, daysQuery, aqiQuery, alertsQuery]
        
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("WEATHER STATUS CODE: \(response.statusCode)")
            }
            
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let tlo = try JSONDecoder().decode(Weather.self, from: data)
                let slo = tlo.forecast
                let thlo = slo.forecastday
                
                completion(.success(thlo))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
        }.resume()
    }
}
