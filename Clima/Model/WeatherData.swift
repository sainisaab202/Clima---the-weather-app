//
//  WeatherData.swift
//  Clima
//
//  Created by GurPreet SaiNi on 2024-03-14.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

//Codable is a typealias i.e. it includes both Decodable + encodable
struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable{
    let temp: Double
    
}

struct Weather: Codable{
    let description: String
    let id: Int
}
