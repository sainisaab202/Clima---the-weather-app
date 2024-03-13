//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

//UITextFieldDelegate for work with go button that will do something on a textfield
class WeatherViewController: UIViewController, UITextFieldDelegate {

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
    }

    @IBAction func btnSearchTouchUp(_ sender: UIButton) {
        txtSearch.endEditing(true)
        print(txtSearch.text!)
    }
    
    //--IS A PART OF UITextFieldDelegate
    //will do the provided action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(txtSearch.text!)
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
        
        txtSearch.text = ""
    }
}

