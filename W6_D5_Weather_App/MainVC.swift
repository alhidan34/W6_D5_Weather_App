//
//  ViewController.swift
//  W6_D5_Weather_App
//
//  Created by Khalid Alhidan on 12/12/2021.
//

import UIKit
import Alamofire

class MainVC: UIViewController {

    @IBOutlet weak var CityNameLabel: UILabel!
    @IBOutlet weak var TempLabel: UILabel!
    @IBOutlet weak var presureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var loaderActivityIndicator: UIActivityIndicatorView!
    
    var cityId = "108410"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loaderActivityIndicator.isHidden = false
        editButton.layer.cornerRadius = 18
        NotificationCenter.default.addObserver(self, selector: #selector(cityChanged), name: NSNotification.Name(rawValue: "cityValueChanged"), object: nil)
        
        getCityWeatherInfo()
        
    }
    
    func getCityWeatherInfo() {
        
        let params = ["id" : cityId , "appid" : "96c8d6594c85d564a2a634fc90d787e2"]
        
        loaderActivityIndicator.startAnimating()
        AF.request("https://api.openweathermap.org/data/2.5/weather", parameters: params, encoder: URLEncodedFormParameterEncoder.default).responseJSON { response  in
            if let result = response.value {
                let JSONDictionary = result as! NSDictionary
                let main = JSONDictionary["main"] as! NSDictionary
                var temp = main["temp"] as! Double
                var presure = main["pressure"] as! Double
                var humidtity = main["humidity"] as! Double
                temp = temp - 272.15
                temp = Double(round(1000 * temp) / 1000)
                self.loaderActivityIndicator.stopAnimating()
                self.loaderActivityIndicator.isHidden = true
                
                self.TempLabel.text = "\(temp)°"
                self.presureLabel.text = "\(presure)"
                self.humidityLabel.text = "\(humidtity)"
            }
        }
        
        
    }
    
    

    @objc func cityChanged(notification : Notification){
        if let city = notification.userInfo?["city"] as? City {
            CityNameLabel.text = city.name
            cityId = city.id
            getCityWeatherInfo()
        
    }
}

}
