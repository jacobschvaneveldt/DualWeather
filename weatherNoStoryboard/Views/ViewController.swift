//
//  ViewController.swift
//  weatherNoStoryboard
//
//  Created by Jacob Schvaneveldt on 9/20/21.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green2 )
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        forecastButton.addTarget(self, action: #selector(forecastButtonPressed), for: .touchUpInside)
        addAllSubviews()
        setupSearchHorSV()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        callUsersLocation()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - PROPERTIES
    let locationManager = CLLocationManager()
    var cTemp: Double?
    var fTemp: Double?
    var cFeelsLike: Double?
    var fFeelsLike: Double?
    var humidity: Int?
    var safeArea: UILayoutGuide {
        self.view.safeAreaLayoutGuide
    }
    var searchTerm: String?
    var cityName: String?
    var locationLatAndLong: String?
    
    //MARK: - VIEWS
    private let currentTempLabel: UILabel = {
        let lbl = UILabel()
    lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.textAlignment = .center
        lbl.font = UIFont(name: weatherStrings.avenirHeavy, size: 500)
        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let currentFeelsLike: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.font = UIFont(name: weatherStrings.avenirLight, size: 24)
        
        return lbl
    }()
    
    //----------------------------------------------
        
    private let humidityLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let windSpeedLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let searchBarTF: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.attributedPlaceholder = NSAttributedString(string: weatherStrings.sbPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: weatherStrings.colorScheme1Yellow)!])
        tf.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green3)!
        tf.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        tf.layer.cornerRadius = 25
        tf.font = UIFont(name: weatherStrings.avenirMedium, size: 24)
        
        return tf
    }()
    
    //----------------------------------------------
    
    private let cityNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Green1)
        lbl.font = UIFont(name: weatherStrings.avenirBook, size: 24)

        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let searchButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: weatherStrings.searchButtonImageName), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        btn.sizeToFit()
        btn.layer.cornerRadius = 25
        btn.titleLabel?.font = UIFont(name: weatherStrings.avenirBook, size: 24)
        return btn
    }()
    
    //----------------------------------------------
    
    private let forecastButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor(named: weatherStrings.colorScheme1Yellow), for: .normal)
        btn.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green3)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .left
        btn.setTitle("forecast", for: .normal)
        btn.sizeToFit()
        btn.layer.cornerRadius = 24
        btn.titleLabel?.font = UIFont(name: weatherStrings.avenirBook, size: 24)
        
        return btn
    }()
    
    //----------------------------------------------
    
    private let currentLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "current"
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let searchHorSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        
        return sv
    }()
    
    //----------------------------------------------
    
    private let forecastButtonView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green3)
        
        return view
    }()
    
    //----------------------------------------------
    
    private let currentWeatherView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green3)
        view.layer.cornerRadius = 25
        
        return view
    }()
    
    //MARK: - FUNCTIONS
    func addAllSubviews() {
        view.addSubview(currentWeatherView)
        view.addSubview(humidityLabel)
        view.addSubview(searchHorSV)
        view.addSubview(cityNameLabel)
        view.addSubview(forecastButtonView)
        view.addSubview(forecastButton)
        view.addSubview(currentLabel)
        view.addSubview(currentTempLabel)
        view.addSubview(currentFeelsLike)
        view.addSubview(windSpeedLabel)
    }
    
    func setupViews() {
        setupCurrentWeatherView()
        setupForecastButton()
        setupForecastButtonView()
        setupHumidityLabel()
        setupCityNameLabel()
        searchBarTF.text = ""
        setupCurrentLabel()
        setupCurrentTempLabel()
    }
    
    //----------------------------------------------
    
    func setupCurrentTempLabel() {
        let currentCTemp = Int(cTemp ?? 0)
        let currentFTemp = Int(fTemp ?? 0)
        currentTempLabel.text = "\(currentCTemp) | \(currentFTemp)"
        currentTempLabel.adjustsFontSizeToFitWidth = true
        currentTempLabel.anchor(top: currentLabel.bottomAnchor,
                                bottom: nil,
                                leading: currentWeatherView.leadingAnchor,
                                trailing: currentWeatherView.trailingAnchor,
                                paddingTop: view.frame.height / 30,
                                paddingBottom: 0,
                                paddingLeft: view.frame.width / 10,
                                paddingRight: view.frame.width / 10,
                                width: currentWeatherView.frame.width,
                                height: 100)
    }
    
    
    
    //----------------------------------------------
    
    func setupHumidityLabel() {
        humidityLabel.text = "humidity: \(humidity ?? 0)"
        humidityLabel.adjustsFontSizeToFitWidth = true
        humidityLabel.frame = CGRect(x: 100, y: 300, width: 100, height: 100)
    }
    
    //----------------------------------------------
    
    func setupSearchHorSV() {
        searchHorSV.addSubview(searchBarTF)
        searchHorSV.addSubview(searchButton)
        
        searchHorSV.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           bottom: nil,
                           leading: safeArea.leadingAnchor,
                           trailing: safeArea.trailingAnchor,
                           paddingTop: -10,
                           paddingBottom: 0,
                           paddingLeft: view.frame.width / 20,
                           paddingRight: view.frame.width / 20,
                           width: view.frame.width / 1.1,
                           height: 50)
        
        self.setupSearchButton()
        self.setupSearchBarTF()
    }
    
    func setupSearchBarTF() {
        searchBarTF.anchor(top: searchHorSV.topAnchor,
                           bottom: searchHorSV.bottomAnchor,
                           leading: searchHorSV.leadingAnchor,
                           trailing: searchHorSV.trailingAnchor,
                           paddingTop: 0,
                           paddingBottom: 0,
                           paddingLeft: 0,
                           paddingRight: 0)
    }
    
    func setupSearchButton() {
        searchButton.anchor(top: searchHorSV.topAnchor,
                            bottom: searchHorSV.bottomAnchor,
                            leading: nil,
                            trailing: searchBarTF.trailingAnchor,
                            paddingTop: 0,
                            paddingBottom: 0,
                            paddingLeft: 0,
                            paddingRight: 0,
                            width: 50,
                            height: 50)
    }
    
    //----------------------------------------------
    
    func setupCityNameLabel() {
        cityNameLabel.anchor(top: nil,
                             bottom: forecastButton.topAnchor,
                             leading: safeArea.leadingAnchor,
                             trailing: safeArea.trailingAnchor,
                             paddingTop: 0,
                             paddingBottom: 0,
                             paddingLeft: view.frame.width / 20,
                             paddingRight: 0,
                             width: 200 ,
                             height: 50)
        
        cityNameLabel.text = cityName?.lowercased()
    }
    
    //----------------------------------------------
    
    func setupForecastButton() {
        forecastButton.anchor(top: cityNameLabel.bottomAnchor,
                              bottom: view.bottomAnchor,
                              leading: safeArea.leadingAnchor,
                              trailing: safeArea.trailingAnchor,
                              paddingTop: 8,
                              paddingBottom: -10,
                              paddingLeft: view.frame.width / 20,
                              paddingRight: view.frame.width / 20,
                              width: view.frame.width,
                              height: 50)
    }
    
    func setupForecastButtonView() {
        forecastButtonView.anchor(top: forecastButton.bottomAnchor,
                                  bottom: view.bottomAnchor,
                                  leading: safeArea.leadingAnchor,
                                  trailing: safeArea.trailingAnchor,
                                  paddingTop: -forecastButton.frame.height / 1.9,
                                  paddingBottom: 0,
                                  paddingLeft: view.frame.width / 20,
                                  paddingRight: view.frame.width / 20,
                                  width: view.frame.width,
                                  height: 50)
    }
    
    //----------------------------------------------
    
    func setupCurrentWeatherView() {
        currentWeatherView.anchor(top: searchHorSV.bottomAnchor,
                                  bottom: nil,
                                  leading: safeArea.leadingAnchor,
                                  trailing: safeArea.trailingAnchor,
                                  paddingTop: 16,
                                  paddingBottom: 0,
                                  paddingLeft: view.frame.width / 20,
                                  paddingRight:  view.frame.width / 20,
                                  width: view.frame.width,
                                  height: view.frame.height / 2)
    }
    
    //----------------------------------------------
    
    func setupCurrentLabel() {
        currentLabel.anchor(top: currentWeatherView.topAnchor,
                            bottom: nil,
                            leading: currentWeatherView.leadingAnchor,
                            trailing: currentWeatherView.trailingAnchor,
                            paddingTop: currentWeatherView.frame.height / 10,
                            paddingBottom: 0,
                            paddingLeft: view.frame.width / 3,
                            paddingRight: view.frame.width / 3,
                            width:  currentWeatherView.frame.width,
                            height: 50)
    }
    
    //----------------------------------------------
    
    func fetchWeather(searchTerm: String) {
        WeatherController.shared.fetchWeather(searchTerm: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let numbers):
                    print(numbers)
                    self.cTemp = numbers.temp_c
                    self.fTemp = numbers.temp_f
                    self.cFeelsLike = numbers.feelslike_c
                    self.fFeelsLike = numbers.feelslike_f
                    self.humidity = numbers.humidity
                    self.setupViews()

                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    func fetchName(searchTerm: String) {
        WeatherController.shared.fetchName(searchTerm: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let name):
                    self.cityName = name.name
                    self.setupViews()

                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    func fetchForcast(searchTerm: String) {
        WeatherController.shared.fetchForcast(searchTerm: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let forcastNumbers):
                    print("------------------------THIS IS THE FORCAST NUMBERS \(forcastNumbers) ---------------------------")
                    
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latAndLong = "\(locValue.latitude),\(locValue.longitude)"
        locationLatAndLong = latAndLong
        self.callUsersLocation()
    }
    
    func callUsersLocation() {
        guard locationLatAndLong != nil else {return}
        searchTerm = locationLatAndLong
        fetchWeather(searchTerm: searchTerm!)
        fetchName(searchTerm: searchTerm!)
        fetchForcast(searchTerm: searchTerm!)
        setupViews()
    }
    
    @objc func searchButtonPressed() {
        guard self.searchBarTF.text != nil else {return}
        searchTerm = self.searchBarTF.text
        fetchWeather(searchTerm: searchTerm!)
        fetchName(searchTerm: searchTerm!)
        fetchForcast(searchTerm: searchTerm!)
    }
    
    @objc func forecastButtonPressed() {
        print("You pushed the button congrats")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}//End of class
