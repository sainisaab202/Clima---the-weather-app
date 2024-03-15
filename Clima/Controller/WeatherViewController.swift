//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

//UITextFieldDelegate for work with go button that will do something on a textfield
class WeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //to make communication between our textfield features and viewController
        //delegate is a variable in UITextFields of type UITextFieldDelegate
        //by setting this UITextField call can talk/notify our viewController about events
        txtSearch.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        //request user to allow permission for location
        locationManager.requestWhenInUseAuthorization()
        //get the location only once
        locationManager.requestLocation()
    }

    @IBAction func btnSearchTouchUp(_ sender: UIButton) {
        txtSearch.endEditing(true)
//        print(txtSearch.text!)
    }
    @IBAction func btnLocationTouchUp(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
}


//MARK: - UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate{
    
    //--IS A PART OF UITextFieldDelegate
    //will do the provided action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print(txtSearch.text!)
        txtSearch.endEditing(true)
        return true
    }
    
//    --IS A PART OF UITextFieldDelegate
//    to confirm if user can deselect the textfield meaning keyborad can hide
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    //--IS A PART OF UITextFieldDelegate
    //get notified when textfield user stopped editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //use text to get the weather for that city...
        if let city = textField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        
        //clear text
        txtSearch.text = ""
    }
}


//MARK: - WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print(weather)
        
        // updating of UI elements should run on main thread
        DispatchQueue.main.async {
            
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(manager.location?.coordinate.latitude.description)
        
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            
            print(lat)
            print(long)
            weatherManager.fetchWeather(latitude: lat, longitude: long)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
