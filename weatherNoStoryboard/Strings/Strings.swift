//
//  Strings.swift
//  weatherNoStoryboard
//
//  Created by Jacob Schvaneveldt on 9/20/21.
//

import Foundation

/*
 family Name: Avenir
 font Name: Avenir-Book a
 font Name: Avenir-Roman
 font Name: Avenir-BookOblique
 font Name: Avenir-Oblique
 font Name: Avenir-Light a
 font Name: Avenir-LightOblique
 font Name: Avenir-Medium a
 font Name: Avenir-MediumOblique
 font Name: Avenir-Heavy a
 font Name: Avenir-HeavyOblique
 font Name: Avenir-Black
 font Name: Avenir-BlackOblique
 */

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
