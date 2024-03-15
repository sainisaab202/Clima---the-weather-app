//
//  WeatherManager.swift
//  Clima
//
//  Created by GurPreet SaiNi on 2024-03-14.
//  Copyright © 2024 App Brewery. All rights reserved.
//

//-------to make an API Call---------
//1: Create a URL
//2: Create a URLSession
//3: Give URLSession a task
//4: Start the task

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    private let APIKey = "someSecret"
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = baseURL() + "&q=" + cityName
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double){
        let urlString = baseURL() + "&lat=" + String(latitude) + "&lon=" + String(longitude)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1: Create a URL
        if let URL = URL(string: urlString){
            
            //2: Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3: Give URLSession a task
//            let task = session.dataTask(with: URL, completionHandler: handle(data:response:error:))
            
//            with closure
            let task = session.dataTask(with: URL) { (data, response, error) in
                if error != nil{
                    //print(error!)
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString)
                    
                    if let weather = parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            
            
            //4: Start the task
            task.resume()
        }
    }
    
//    completion handler
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if error != nil{
            print(error!)
            return
        }
        
        if let safeData = data{
            //just to check what is inside data
            let dataString = String(data: safeData, encoding: .utf8)
//            print(dataString)
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        
        let decorder = JSONDecoder()
        do{
            let decodedData = try decorder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
//            print(decodedData.weather[0].description)
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        }catch{
            //print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    /**
     Will return the base URL with the API KEY
     */
    private func baseURL() -> String{
        return weatherURL + "&appid=" + APIKey
    }
}
