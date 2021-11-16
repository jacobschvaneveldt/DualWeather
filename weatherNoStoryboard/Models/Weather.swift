//
//  Weather.swift
//  weatherNoStoryboard
//
//  Created by Jacob Schvaneveldt on 9/20/21.
//

import Foundation

struct Weather: Codable {
    let current: CurrentWeatherNumbers
    let location: Name
    let forecast: ForecastWeatherNumbers
}

struct CurrentWeatherNumbers: Codable {
    let temp_c: Double
    let temp_f: Double
    let humidity: Int
    let feelslike_c: Double
    let feelslike_f: Double
    let wind_mph: Double
    let wind_kph: Double
    let wind_dir: String
    let condition: Condition
}

struct Condition: Codable {
    let text: String
}

struct Name: Codable {
    let name: String
}

struct ForecastWeatherNumbers: Codable {
    let forecastday: [_Day]
}

struct _Day: Codable {
    let date: String
    let day: ForcastNumbers
}

struct ForcastNumbers: Codable {
    let maxtemp_c: Double
    let maxtemp_f: Double
    let mintemp_c: Double
    let mintemp_f: Double
    let condition: ForecastCondition
}

struct ForecastCondition: Codable {
    let text: String
}

