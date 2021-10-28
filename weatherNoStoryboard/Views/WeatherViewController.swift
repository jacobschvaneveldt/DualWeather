//
//  ViewController.swift
//  weatherNoStoryboard
//
//  Created by Jacob Schvaneveldt on 9/20/21.
//

import UIKit
import CoreLocation
import MapKit

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
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
    var locationManager = CLLocationManager()
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
    var windMph: Double?
    var windKph: Double?
    var windDirection: String?
    var weatherIconString: String?
    
    //MARK: - VIEWS
    private let currentTempLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.textAlignment = .center
        lbl.font = UIFont(name: weatherStrings.avenirHeavy, size: 300)
        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let currentFeelsLikeLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.font = UIFont(name: weatherStrings.avenirMedium, size: 18)
        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let humidityLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.font = UIFont(name: weatherStrings.avenirMedium, size: 18)
        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let windSpeedLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.font = UIFont(name: weatherStrings.avenirMedium, size: 18)
        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let searchBarTF: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.attributedPlaceholder = NSAttributedString(string: weatherStrings.sbPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: weatherStrings.colorScheme1Yellow)!])
        tf.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green3)!
        tf.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        tf.layer.cornerRadius = 30
        tf.font = UIFont(name: weatherStrings.avenirMedium, size: 24)
        tf.setLeftPaddingPoints(16)
        
        return tf
    }()
    
    //----------------------------------------------
    
    private let cityNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Green1)
        lbl.font = UIFont(name: weatherStrings.avenirBook, size: 48)
        lbl.adjustsFontSizeToFitWidth = true
        
        
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
        btn.layer.cornerRadius = 30
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
        btn.titleLabel?.font = UIFont(name: weatherStrings.avenirBook, size: 36)
        btn.titleLabel?.layoutMargins = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        
        
        return btn
    }()
    
    //----------------------------------------------
    
    private let currentLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "current"
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.font = UIFont(name: weatherStrings.avenirLight, size: 32)
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
        view.layer.cornerRadius = 64
        
        return view
    }()
    
    //----------------------------------------------
    
    private let windDirectionUIImage: UIImageView = {
        let image = UIImageView()
        image.tintColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        
        return image
    }()
    
    //----------------------------------------------
    
    private let windSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.backgroundColor = .red
        
        return sv
    }()
    
    //----------------------------------------------
    
    private let weatherStatusIcon: UIImageView = {
       let iv = UIImageView()
        
        return iv
    }()
    
    //MARK: - FUNCTIONS
    func addAllSubviews() {
        view.addSubview(currentWeatherView)
        view.addSubview(searchHorSV)
        view.addSubview(windSpeedLabel)
        view.addSubview(cityNameLabel)
        view.addSubview(forecastButtonView)
        view.addSubview(forecastButton)
        view.addSubview(currentLabel)
        view.addSubview(currentTempLabel)
        view.addSubview(currentFeelsLikeLabel)
        view.addSubview(humidityLabel)
        view.addSubview(windDirectionUIImage)
        view.addSubview(weatherStatusIcon)
    }
    
    func setupViews() {
        setupCurrentWeatherView()
        setupCurrentTempLabel()
        setupForecastButton()
        setupForecastButtonView()
        setupWindSpeedLabel()
        setupCityNameLabel()
        searchBarTF.text = ""
        setupCurrentLabel()
        setupCurrentFeelsLIkeLabel()
        setupHumidityLabel()
        setupStatusIcon()
    }
    
    //----------------------------------------------
    //JSWAN - get opinion on centered at line or all text centered
    func setupCurrentTempLabel() {
        let currentCTemp = Int(cTemp ?? 0)
        let currentFTemp = Int(fTemp ?? 0)
        let numberOfCTempInts = intToStringCount(int: currentCTemp)
        
        if numberOfCTempInts == 1 {
            currentTempLabel.text = "0\(currentCTemp) | \(currentFTemp)"
        } else {
            currentTempLabel.text = "\(currentCTemp) | \(currentFTemp)"
        }
        currentTempLabel.adjustsFontSizeToFitWidth = true
        currentTempLabel.adjustsFontForContentSizeCategory = true
        currentTempLabel.textAlignment = .center
        currentTempLabel.anchor(top: currentLabel.bottomAnchor,
                                bottom: currentFeelsLikeLabel.topAnchor,
                                leading: currentWeatherView.leadingAnchor,
                                trailing: currentWeatherView.trailingAnchor,
                                paddingTop: 0,
                                paddingBottom: 0,
                                paddingLeft: view.frame.width / 10,
                                paddingRight: view.frame.width / 10)
    }
    
    func intToStringCount(int: Int) -> Int {
        let int = int
        let string = String(int)
        return string.count
    }
    
    
    //----------------------------------------------
    
    func setupCurrentFeelsLIkeLabel() {
        let currentCTemp = Int(cFeelsLike ?? 0)
        let currentFTemp = Int(fFeelsLike ?? 0)
        
        currentFeelsLikeLabel.text = "feels like: \(currentCTemp) | \(currentFTemp)"
        currentFeelsLikeLabel.textAlignment = .center
        currentFeelsLikeLabel.anchor(top: currentTempLabel.bottomAnchor,
                                     bottom: humidityLabel.topAnchor,
                                     leading: currentWeatherView.leadingAnchor,
                                     trailing: currentWeatherView.trailingAnchor,
                                     paddingTop: 16,
                                     paddingBottom: -16,
                                     paddingLeft: view.frame.width / 20,
                                     paddingRight: view.frame.width / 20,
                                     width: currentWeatherView.frame.width,
                                     height: 18)
    }
    
    //----------------------------------------------
    
    func setupHumidityLabel() {
        
        humidityLabel.text = "humidity: \(humidity ?? 0)"
        humidityLabel.textAlignment = .center
        humidityLabel.anchor(top: nil,
                             bottom: windSpeedLabel.topAnchor,
                             leading: currentWeatherView.leadingAnchor,
                             trailing: currentWeatherView.trailingAnchor,
                             paddingTop: 0,
                             paddingBottom: -14,
                             paddingLeft: view.frame.width / 20,
                             paddingRight: view.frame.width / 20,
                             width: currentWeatherView.frame.width,
                             height: 18)
    }
    
    //----------------------------------------------
    
    func setupWindSpeedLabel() {
        let mphWind = Int(windMph ?? 0)
        let kphWind = Int(windKph ?? 0)
        var windDirectionImage = windDirection ?? ""
        
        switch windDirectionImage {
        case "N":
            windDirectionImage = "arrow.up.circle.fill"
            print(windDirectionImage)
            
        case "NE":
            windDirectionImage = "arrow.up.right.circle.fill"
            print(windDirectionImage)
            
        case "E":
            windDirectionImage = "arrow.right.circle.fill"
            print(windDirectionImage)
            
        case "SE":
            windDirectionImage = "arrow.down.right.circle.fill"
            print(windDirectionImage)
            
        case "S":
            windDirectionImage = "arrow.down.circle.fill"
            print(windDirectionImage)
            
        case "SW":
            windDirectionImage = "arrow.down.left.circle.fill"
            print(windDirectionImage)
            
        case "W":
            windDirectionImage = "arrow.left.circle.fill"
            print(windDirectionImage)
            
        case "NW":
            windDirectionImage = "arrow.up.left.circle.fill"
            print(windDirectionImage)
            
        default:
            windDirectionImage = "arrow.up.circle.fill"
            print(windDirectionImage)
        }
        
        let arrowImage = UIImage(systemName: windDirectionImage)
        let coloredArrowImage = (arrowImage?.withTintColor(UIColor(named: weatherStrings.colorScheme1Yellow)!))!
        let arrowAttachment = NSTextAttachment(image: coloredArrowImage)
        
        let attachmentString = NSAttributedString(attachment: arrowAttachment)
        let myString = NSMutableAttributedString(string: "wind speed: \(kphWind) | \(mphWind) ")
        myString.append(attachmentString)
        
        windSpeedLabel.attributedText = myString
        windSpeedLabel.textAlignment = .center
//        windSpeedLabel.backgroundColor = .blue
        windSpeedLabel.sizeToFit()
        windSpeedLabel.anchor(top: nil,
                              bottom: currentWeatherView.bottomAnchor,
                              leading: currentWeatherView.leadingAnchor,
                              trailing: currentWeatherView.trailingAnchor,
                              paddingTop: 0,
                              paddingBottom: -view.frame.height / 22,
                              paddingLeft: 0,
                              paddingRight: 0,
                              height: 20)
        
//        windDirectionUIImage.backgroundColor = .yellow
//        windDirectionUIImage.anchor(top: nil,
//                                    bottom: currentWeatherView.bottomAnchor,
//                                    leading: windSpeedLabel.trailingAnchor,
//                                    trailing: currentWeatherView.trailingAnchor,
//                                    paddingTop: 0,
//                                    paddingBottom: -view.frame.height / 22,
//                                    paddingLeft: 0,
//                                    paddingRight: 0,
//                                    width: 18,
//                                    height: 18)
//        windDirectionUIImage.image = UIImage(systemName: windDirectionImage)
    }
    
    func setupWindSV() {
        windSV.addSubview(windSpeedLabel)
        windSV.addSubview(windDirectionUIImage)
        
        windSV.anchor(top: nil,
                      bottom: currentWeatherView.bottomAnchor,
                      leading: currentWeatherView.leadingAnchor,
                      trailing: nil,
                      paddingTop: 0,
                      paddingBottom: -view.frame.height / 22,
                      paddingLeft: 0,
                      paddingRight: 0,
                      width: windSpeedLabel.frame.width + windDirectionUIImage.frame.width,
                      height: 18)
        windSV.alignment = .center
        windSV.distribution = .equalSpacing
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
                           height: 60)
        
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
                            width: 60,
                            height: 60)
    }
    
    //----------------------------------------------
    
    func setupCityNameLabel() {
        cityNameLabel.anchor(top: nil,
                             bottom: forecastButton.topAnchor,
                             leading: safeArea.leadingAnchor,
                             trailing: safeArea.trailingAnchor,
                             paddingTop: 0,
                             paddingBottom: -view.frame.height / 90,
                             paddingLeft: view.frame.width / 20 + 16,
                             paddingRight: view.frame.width / 20,
                             width: 200 ,
                             height: 60)
        cityNameLabel.text = cityName?.lowercased()
    }
    
    //----------------------------------------------
    
    func setupForecastButton() {
        forecastButton.anchor(top: cityNameLabel.bottomAnchor,
                              bottom: view.bottomAnchor,
                              leading: safeArea.leadingAnchor,
                              trailing: safeArea.trailingAnchor,
                              paddingTop: 8,
                              paddingBottom: -8,
                              paddingLeft: view.frame.width / 20,
                              paddingRight: view.frame.width / 20,
                              width: view.frame.width,
                              height: 60)
        forecastButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
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
                                  height: view.frame.height / 2.5)
    }
    
    //----------------------------------------------
    
    func setupCurrentLabel() {
        currentLabel.textAlignment = .center
        currentLabel.anchor(top: currentWeatherView.topAnchor,
                            bottom: currentTempLabel.topAnchor,
                            leading: currentWeatherView.leadingAnchor,
                            trailing: currentWeatherView.trailingAnchor,
                            paddingTop: view.frame.height / 30,
                            paddingBottom: 0,
                            paddingLeft: view.frame.width / 5,
                            paddingRight: view.frame.width / 5,
                            width:  currentWeatherView.frame.width,
                            height: 32)
    }
    
    //----------------------------------------------
    
    func setupStatusIcon() {
        var iconImageName = weatherIconString ?? ""
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch iconImageName {
        case "Sunny":
            iconImageName = iconStrings.sunIcon
            
        case "Clear":
            iconImageName = iconStrings.moonIcon
            
        case "Partly cloudy":
            switch hour {
            case 6..<19:
                iconImageName = iconStrings.sunCloudIcon
            default:
                iconImageName = iconStrings.cloudMoonIcon
            }
            
        case "Cloudy":
            iconImageName = iconStrings.twoCloudsIcon
            
        case "Overcast":
            iconImageName = iconStrings.twoCloudsIcon
            
        case "Mist":
            iconImageName = iconStrings.fogIcon
            
        case "Patchy rain possible":
            iconImageName = iconStrings.singleRainIcon
            
        case "Patchy snow possible":
            iconImageName = iconStrings.singleSnowFlakeIcon
            
        case "Patchy sleet possible":
            iconImageName = iconStrings.singleRainIcon
            
        case "Patchy freezing drizzle possible":
            iconImageName = iconStrings.singleRainIcon
            
        case "Thundery outbreaks possible":
            iconImageName = iconStrings.thunderStormIcon
            
        case "Blowing snow":
            iconImageName = iconStrings.singleSnowFlakeIcon
            
        case "Blizzard":
            iconImageName = iconStrings.threeSnowFlakesIcon
            
        case "Fog":
            iconImageName = iconStrings.fogIcon
            
        case "Freezing fog":
            iconImageName = iconStrings.fogIcon
            
        case "Patchy light drizzle":
            iconImageName = iconStrings.singleRainIcon
            
        case "Light drizzle":
            iconImageName = iconStrings.singleRainIcon
            
        case "Freezing drizzle":
            iconImageName = iconStrings.singleRainIcon
            
        case "Heavy freezing drizzle":
            iconImageName = iconStrings.threeRainIcon
            
        case "Patchy light rain":
            iconImageName = iconStrings.singleRainIcon
            
        case "Light rain":
            iconImageName = iconStrings.singleRainIcon
            
        case "Moderate rain at times":
            iconImageName = iconStrings.singleRainIcon
            
        case "Moderate rain":
            iconImageName = iconStrings.singleRainIcon
            
        case "Heavy rain at times":
            iconImageName = iconStrings.threeRainIcon
            
        case "Heavy rain":
            iconImageName = iconStrings.threeRainIcon
            
        case "Light freezing rain":
            iconImageName = iconStrings.singleRainIcon
            
        case "Moderate or heavy freezing rain":
            iconImageName = iconStrings.threeRainIcon
            
        case "Light sleet":
            iconImageName = iconStrings.singleSnowFlakeIcon
            
        case "Moderate or heavy sleet":
            iconImageName = iconStrings.threeSnowFlakesIcon
            
        case "Patchy light snow":
            iconImageName = iconStrings.singleSnowFlakeIcon
            
        case "Light snow":
            iconImageName = iconStrings.singleSnowFlakeIcon
            
        case "Patchy moderate snow":
            iconImageName = iconStrings.singleSnowFlakeIcon
            
        case "Moderate snow":
            iconImageName = iconStrings.threeSnowFlakesIcon
            
        case "Patchy heavy snow":
            iconImageName = iconStrings.threeSnowFlakesIcon
            
        case "Heavy snow":
            iconImageName = iconStrings.threeSnowFlakesIcon
            
        case "Ice pellets":
            iconImageName = iconStrings.snowDotsIcon
            
        case "Light rain shower":
            iconImageName = iconStrings.singleRainIcon
            
        case "Moderate or heavy rain shower":
            iconImageName = iconStrings.threeRainIcon
            
        case "Torrential rain shower":
            iconImageName = iconStrings.windCloudRainIcon
            
        case "Light sleet showers":
            iconImageName = iconStrings.singleSnowFlakeIcon
            
        case "Moderate or heavy sleet showers":
            iconImageName = iconStrings.threeSnowFlakesIcon
            
        case "Light snow showers":
            iconImageName = iconStrings.singleSnowFlakeIcon
            
        case "Moderate or heavy snow showers":
            iconImageName = iconStrings.threeSnowFlakesIcon
            
        case "Light showers of ice pellets":
            iconImageName = iconStrings.snowDotsIcon
            
        case "Moderate or heavy showers of ice pellets":
            iconImageName = iconStrings.snowDotsIcon
            
        case "Patchy light rain with thunder":
            iconImageName = iconStrings.thunderStormIcon
            
        case "Moderate or heavy rain with thunder":
            iconImageName = iconStrings.heavyThunderStormsIcon
            
        case "Patchy light snow with thunder":
            iconImageName = iconStrings.thunderStormIcon
            
        case "Moderate or heavy snow with thunder":
            iconImageName = iconStrings.heavyThunderStormsIcon
            
        default:
            iconImageName = ""
        }
        
        
        weatherStatusIcon.image = UIImage(named: iconImageName)
        weatherStatusIcon.contentMode = .scaleAspectFill
        weatherStatusIcon.contentMode = .scaleAspectFit
        
        weatherStatusIcon.anchor(top: currentWeatherView.bottomAnchor,
                                 bottom: cityNameLabel.topAnchor,
                                 leading: safeArea.leadingAnchor,
                                 trailing: safeArea.trailingAnchor,
                                 paddingTop: 16,
                                 paddingBottom: 0,
                                 paddingLeft: view.frame.width / 10,
                                 paddingRight: view.frame.width / 10)
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
                    self.windKph = numbers.wind_kph
                    self.windMph = numbers.wind_mph
                    self.windDirection = numbers.wind_dir
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
    
    func fetchIcon(searchTerm: String) {
        WeatherController.shared.fetchIcon(searchTerm: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let condition):
                    self.weatherIconString = condition.text
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
        fetchIcon(searchTerm: searchTerm!)
//        fetchForcast(searchTerm: searchTerm!)
        setupViews()
        locationManager.stopUpdatingLocation()
        }
    
    @objc func searchButtonPressed() {
        guard self.searchBarTF.text != nil else {return}
        searchTerm = self.searchBarTF.text
        fetchWeather(searchTerm: searchTerm!)
        fetchName(searchTerm: searchTerm!)
        fetchIcon(searchTerm: searchTerm!)
        locationManager.stopUpdatingLocation()
//        fetchForcast(searchTerm: searchTerm!)
    }
    
    @objc func forecastButtonPressed() {
        print("You pushed the button congrats")
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}//End of class
