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
        view.backgroundColor = .systemBackground
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
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
    private let cTempLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .blue
        
        return lbl
    }()
    
    private let fTempLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .red
        
        return lbl
    }()

    private let cFeelsLikeTempLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .link
        
        return lbl
    }()

    private let fFeelsLikeTempLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .systemPink
        
        return lbl
    }()

    private let humidityLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .lightGray
        
        return lbl
    }()
    
    private let searchBarTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = weatherStrings.sbPlaceholder
        
        return tf
    }()
    
    private let cityNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .blue
        
        return lbl
    }()
    
    private let searchButton: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: weatherStrings.searchButtonImageName), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .red
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        btn.sizeToFit()
        
        return btn
    }()
    
    private let searchHorSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        
        return sv
    }()
    
    private let cHorSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        
        return sv
    }()
    
    private let fHorSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        
        return sv
    }()
    
    //MARK: - FUNCTIONS
    func addAllSubviews() {
        view.addSubview(humidityLabel)
        view.addSubview(searchHorSV)
        view.addSubview(cHorSV)
        view.addSubview(fHorSV)
        view.addSubview(cityNameLabel)
    }
    
    func setupViews() {
        setupCHorSV()
        setupFHorSV()
        setupHumidityLabel()
        setupCityNameLabel()
        searchBarTF.text = ""
    }
    
    //----------------------------------------------
    
    func setupCHorSV() {
        cHorSV.addSubview(cTempLabel)
        cHorSV.addSubview(cFeelsLikeTempLabel)
        cHorSV.alignment = .fill
        cHorSV.distribution = .fillProportionally
        
        cHorSV.anchor(top: searchHorSV.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 16, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: view.frame.width, height: 50)
        
        setupCTempLabel()
        setupCFeelsLikeLabel()
    }
    
    func setupCTempLabel() {
        let number = Int(cTemp ?? 0)
        cTempLabel.text = "C: \(number)"
        cTempLabel.anchor(top: cHorSV.topAnchor, bottom: cHorSV.bottomAnchor, leading: cHorSV.leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 100, height: cHorSV.frame.height)
    }
      
    func setupCFeelsLikeLabel() {
        let number = Int(cFeelsLike ?? 0)
        cFeelsLikeTempLabel.text = "Feels like C: \(number)"
        cFeelsLikeTempLabel.adjustsFontSizeToFitWidth = true
        cFeelsLikeTempLabel.anchor(top: cHorSV.topAnchor, bottom: cHorSV.bottomAnchor, leading: nil, trailing: cHorSV.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 100, height: cHorSV.frame.height)
    }
    
    //----------------------------------------------
    
    func setupFHorSV() {
        fHorSV.addSubview(fTempLabel)
        fHorSV.addSubview(fFeelsLikeTempLabel)
        fHorSV.alignment = .fill
        fHorSV.distribution = .fillProportionally
        
        fHorSV.anchor(top: cHorSV.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: view.frame.width, height: 50)
        
        setupFTempLabel()
        setupFFeelsLikeLabel()
    }
    
    func setupFTempLabel() {
        let number = Int(fTemp ?? 0)
        fTempLabel.text = "F: \(number)"
        fTempLabel.anchor(top: fHorSV.topAnchor, bottom: fHorSV.bottomAnchor, leading: fHorSV.leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 100, height: fHorSV.frame.height)
    }
    
    func setupFFeelsLikeLabel() {
        let number = Int(fFeelsLike ?? 0)
        fFeelsLikeTempLabel.text = "Feels like F: \(number)"
        fFeelsLikeTempLabel.adjustsFontSizeToFitWidth = true
        fFeelsLikeTempLabel.anchor(top: fHorSV.topAnchor, bottom: fHorSV.bottomAnchor, leading: nil, trailing: fHorSV.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 100, height: fHorSV.frame.height)
    }
    
    //----------------------------------------------
    
    func setupHumidityLabel() {
        humidityLabel.text = "Humidity: \(humidity ?? 0)"
        humidityLabel.adjustsFontSizeToFitWidth = true
        humidityLabel.frame = CGRect(x: 100, y: 300, width: 100, height: 100)
    }
    
    //----------------------------------------------
    
    func setupSearchHorSV() {
        searchHorSV.addSubview(searchBarTF)
        searchHorSV.addSubview(searchButton)
        
        searchHorSV.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: view.frame.height, height: 50)
        
        self.setupSearchBarTF()
        self.setupSearchButton()
    }
    
    func setupSearchBarTF() {
        searchBarTF.anchor(top: searchHorSV.topAnchor, bottom: searchHorSV.bottomAnchor, leading: searchHorSV.leadingAnchor, trailing: searchButton.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0)
    }
    
    func setupSearchButton() {
        searchButton.anchor(top: searchHorSV.topAnchor, bottom: searchHorSV.bottomAnchor, leading: searchBarTF.trailingAnchor, trailing: searchHorSV.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 50, height: 50)
    }
    
    //----------------------------------------------
    
    func setupCityNameLabel() {
        cityNameLabel.anchor(top: nil, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 16, paddingLeft: 0, paddingRight: 0, width: 200 , height: 50)
        cityNameLabel.text = cityName
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
        setupViews()
    }
    
    @objc func searchButtonPressed() {
        guard self.searchBarTF.text != nil else {return}
        searchTerm = self.searchBarTF.text
        fetchWeather(searchTerm: searchTerm!)
        fetchName(searchTerm: searchTerm!)
        
    }
    

}//End of class

