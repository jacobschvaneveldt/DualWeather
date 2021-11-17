//
//  Strings.swift
//  weatherNoStoryboard
//
//  Created by Jacob Schvaneveldt on 9/20/21.
//

import Foundation

struct weatherStrings {
    //MARK: - WEATHER APIS
    static let baseURL = URL(string: "http://api.weatherapi.com/v1/forecast.json?")
    static let apiKeyName = "key"
    static let apiKeyValue = "3ef17e77bd2e4f96b71235638212109"
    static let searchValue = "q"
    static let days = "days"
    static let aqi = "aqi"
    static let alerts = "alerts"
    
    //MARK: - VIEW CONTROLLER
    static let sbPlaceholder = "search"
    static let searchButtonImageName = "magnifyingglass.circle"
    
    //MARK: - COLORS
    static let colorScheme1Yellow = "colorScheme1Yellow"
    static let colorScheme1Green1 = "colorScheme1Green1"
    static let colorScheme1Green2 = "colorScheme1Green2"
    static let colorScheme1Green3 = "colorScheme1Green3"
    
    //MARK: - FONT NAMES
    static let avenirBook = "Avenir-Book"
    static let avenirLight = "Avenir-Light"
    static let avenirMedium = "Avenir-Medium"
    static let avenirHeavy = "Avenir-Heavy"
}

struct iconStrings {
    static let cloudMoonIcon = "cloudMoonIcon"
    static let fogIcon = "fogIcon"
    static let heavyThunderStormsIcon = "heavyThunderStormsIcon"
    static let moonIcon = "moonIcon"
    static let singleCloudIcon = "singleCloudIcon"
    static let singleRainIcon = "singleRainIcon"
    static let singleSnowFlakeIcon = "singleSnowFlakeIcon"
    static let snowDotsIcon = "snowDotsIcon"
    static let sunCloudIcon = "sunCloudIcon"
    static let sunIcon = "sunIcon"
    static let threeRainIcon = "threeRainIcon"
    static let threeSnowFlakesIcon = "threeSnowFlakesIcon"
    static let thunderStormIcon = "thunderStormIcon"
    static let twoCloudsIcon = "twoCloudsIcon"
    static let windCloudRainIcon = "windCloudRainIcon"
    static let windIcon = "windIcon"
}
