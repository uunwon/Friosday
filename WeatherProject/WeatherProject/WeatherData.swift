//
//  WeatherData.swift
//  WeatherProject
//
//  Created by uunwon on 6/25/24.
//

import Foundation

struct WeatherData: Codable {
    let temperature: Double
    let description: String
    let humidity: Double
    let windSpeed: Double
}
