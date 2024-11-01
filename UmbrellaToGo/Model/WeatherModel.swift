//
//  WeatherModel.swift
//  UmbrellaToGo
//
//  Created by yfedorov on 31.10.2024.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [Weather]

    var hasRain: Bool {
        return weather.contains { $0.main.lowercased().contains("rain") }
    }
}

struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let main: String
    let description: String
}
