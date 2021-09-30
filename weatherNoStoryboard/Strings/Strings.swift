//
//  Strings.swift
//  weatherNoStoryboard
//
//  Created by Jacob Schvaneveldt on 9/20/21.
//

import Foundation

struct weatherStrings {
    //MARK: - WEATHER APIS
    static let baseURL = URL(string: "http://api.weatherapi.com/v1/current.json?")
    static let apiKeyName = "key"
    static let apiKeyValue = "3ef17e77bd2e4f96b71235638212109"
    static let searchValue = "q"
    static let aqi = "aqi"
    
    //MARK: - VIEW CONTROLLER
    static let sbPlaceholder = "Enter city name or zip code here"
    static let searchButtonImageName = "magnifyingglass.circle"
}
