//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weathermanager = WeatherManager()
    let LocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.delegate = self
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.requestLocation()
        
        weathermanager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        LocationManager.requestLocation()
    }
    
}

//MARK:- UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
     @IBAction func searchPressed(_ sender: UIButton) {
         searchTextField.endEditing(true)
         //print(searchTextField.text!)
     }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         searchTextField.endEditing(true)
         print(searchTextField.text!)
         return true
     }
     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
         if textField.text != ""{
             return true
         }
         else{
             textField.placeholder = "Type something"
             return false
         }
     }
    func textFieldDidEndEditing(_ textField: UITextField) {
         if let city = searchTextField.text {
         weathermanager.fetchWeather(cityName: city)
         }
         searchTextField.text = ""
     }
    
}


//MARK:- WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weathermanager: WeatherManager, weather: WeatherModel) {
         DispatchQueue.main.async{
         self.temperatureLabel.text = weather.temperatureString
         self.conditionImageView.image = UIImage(systemName: weather.conditionName)
         self.cityLabel.text = weather.cityName
         }
         
     }
     
     func didFailWithError(error: Error) {
         print(error)
     }
    
}

//MARK:- CLLocationManagerDelegate


extension WeatherViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            LocationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weathermanager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

