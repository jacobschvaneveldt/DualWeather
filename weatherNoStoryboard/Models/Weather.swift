//
//  Weather.swift
//  weatherNoStoryboard
//
//  Created by Jacob Schvaneveldt on 9/20/21.
//

import Foundation

struct Weather: Codable {
    let current: Numbers
    let location: Name
}

struct Numbers: Codable {
    let temp_c: Double
    let temp_f: Double
    let humidity: Int
    let feelslike_c: Double
    let feelslike_f: Double
}

struct Name: Codable {
    let name: String
}
