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
        view.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green2)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        forecastButton.addTarget(self, action: #selector(forecastButtonPressed), for: .touchUpInside)
        let viewTapped = UITapGestureRecognizer(target: self, action: #selector(forecastBackgroundViewPressed))
        forecastBackgroundView.addGestureRecognizer(viewTapped)
        addAllSubviews()
        hideSubviewsDuringLoading()
        setupCurrentWeatherView()
        setupSearchHorSV()
        setupIfLocationIsntEnabled()
        setupLoadingView()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        if loadingView.isHidden == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.loadingView.isHidden = true
                self.loadingLabel.isHidden = true
            }
        }
        addObservers()
//        removeObservers()
    }
    
    fileprivate func addObservers() {
          NotificationCenter.default.addObserver(self,
                                                 selector: #selector(applicationDidBecomeActive),
                                                 name: UIApplication.didBecomeActiveNotification,
                                                 object: nil)
        }

    fileprivate func removeObservers() {
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        }

    @objc fileprivate func applicationDidBecomeActive() {
        fetchWeather(searchTerm: searchTerm!)
        fetchForecast(searchTerm: searchTerm!)
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
    var forecastDates: [String] = []
    var forecastHighCTemp: [Double] = []
    var forecastHighFTemp: [Double] = []
    var forecastLowCTemp: [Double] = []
    var forecastLowFTemp: [Double] = []
    var forecastIconString: [String] = []
    var fetchWeatherBool: Bool = false
    var fetchForecastBool: Bool = false
    
    
    //MARK: - VIEWS
    private let ifLocationIsntEnabledLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "if you do not have location services enabled, please consider enabling them to recieve the weather of your current location, or enter a city in the search bar above"
        lbl.font = UIFont(name: weatherStrings.avenirLight, size: 24)
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        
        return lbl
    }()
    
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
    
    //----------------------------------------------
    
    private let forecastTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green3)
        tv.layer.cornerRadius = 24
        tv.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        tv.largeContentTitle = "forecast"
        
        return tv
    }()
    
    //----------------------------------------------
    
    private let forecastBackgroundView: UIView = {
        let view = UIView()
        view.alpha = 0.9
        
        return view
    }()
    
    //----------------------------------------------
    
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green2)
        
        return view
    }()
    
    //----------------------------------------------
    
    private let loadingLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "loading..."
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.textAlignment = .center
        lbl.font = UIFont(name: weatherStrings.avenirLight, size: 24)
        
        return lbl
    }()
    
    //MARK: - FUNCTIONS
    func addAllSubviews() {
        view.addSubview(currentWeatherView)
        view.addSubview(searchHorSV)
        view.addSubview(ifLocationIsntEnabledLabel)
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
        view.addSubview(forecastBackgroundView)
        view.addSubview(forecastTableView)
        view.addSubview(loadingView)
        view.addSubview(loadingLabel)
    }
    
    func setupViews() {
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
    
    func hideSubviewsDuringLoading() {
        windSpeedLabel.isHidden = true
        cityNameLabel.isHidden = true
        forecastButtonView.isHidden = true
        forecastButton.isHidden = true
        currentLabel.isHidden = true
        currentTempLabel.isHidden = true
        currentFeelsLikeLabel.isHidden = true
        humidityLabel.isHidden = true
        windDirectionUIImage.isHidden = true
        weatherStatusIcon.isHidden = true
        forecastBackgroundView.isHidden = true
        forecastTableView.isHidden = true
    }
    
    //----------------------------------------------
    
    func showSubviewsAfterLoading() {
        windSpeedLabel.isHidden = false
        cityNameLabel.isHidden = false
        forecastButtonView.isHidden = false
        forecastButton.isHidden = false
        currentLabel.isHidden = false
        currentTempLabel.isHidden = false
        currentFeelsLikeLabel.isHidden = false
        humidityLabel.isHidden = false
        windDirectionUIImage.isHidden = false
        weatherStatusIcon.isHidden = false
        forecastBackgroundView.isHidden = false
        forecastTableView.isHidden = false

    }
    
    //----------------------------------------------
    
    func setupIfLocationIsntEnabled() {
        ifLocationIsntEnabledLabel.anchor(top: searchHorSV.bottomAnchor,
                                         bottom: nil,
                                         leading: safeArea.leadingAnchor,
                                         trailing: safeArea.trailingAnchor,
                                         paddingTop: view.frame.height / 18,
                                         paddingBottom: 0,
                                         paddingLeft: view.frame.width / 10,
                                         paddingRight:  view.frame.width / 10,
                                         width: view.frame.width,
                                         height: view.frame.height / 3)
    }
    
    //----------------------------------------------
    
    func setupLoadingView() {
        loadingView.anchor(top: view.topAnchor,
                           bottom: view.bottomAnchor,
                           leading: view.leadingAnchor,
                           trailing: view.trailingAnchor,
                           paddingTop: 0,
                           paddingBottom: 0,
                           paddingLeft: 0,
                           paddingRight: 0)
        
        loadingLabel.anchor(top: view.topAnchor,
                            bottom: view.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            paddingTop: 0,
                            paddingBottom: 0,
                            paddingLeft: 0,
                            paddingRight: 0)
    }
    
    //----------------------------------------------
    
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
        let numberOfCTempInts = intToStringCount(int: currentCTemp)
        
        if numberOfCTempInts == 1 {
            currentFeelsLikeLabel.text = "feels like: 0\(currentCTemp) | \(currentFTemp)"
        } else {
            currentFeelsLikeLabel.text = "feels like: \(currentCTemp) | \(currentFTemp)"
        }
        
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
            
        case "NNE":
            windDirectionImage = "arrow.up.right.circle.fill"
            print(windDirectionImage)
            
        case "NE":
            windDirectionImage = "arrow.up.right.circle.fill"
            print(windDirectionImage)
            
        case "ENE":
            windDirectionImage = "arrow.up.right.circle.fill"
            print(windDirectionImage)
            
        case "E":
            windDirectionImage = "arrow.right.circle.fill"
            print(windDirectionImage)
            
        case "ESE":
            windDirectionImage = "arrow.down.right.circle.fill"
            print(windDirectionImage)
            
        case "SE":
            windDirectionImage = "arrow.down.right.circle.fill"
            print(windDirectionImage)
            
        case "SSE":
            windDirectionImage = "arrow.down.right.circle.fill"
            print(windDirectionImage)
            
        case "S":
            windDirectionImage = "arrow.down.circle.fill"
            print(windDirectionImage)
            
        case "SSW":
            windDirectionImage = "arrow.down.left.circle.fill"
            print(windDirectionImage)
            
            
        case "SW":
            windDirectionImage = "arrow.down.left.circle.fill"
            print(windDirectionImage)
            
        case "WSW":
            windDirectionImage = "arrow.down.left.circle.fill"
            print(windDirectionImage)
            
            
        case "W":
            windDirectionImage = "arrow.left.circle.fill"
            print(windDirectionImage)
            
        case "WNW":
            windDirectionImage = "arrow.up.left.circle.fill"
            print(windDirectionImage)
            
            
        case "NW":
            windDirectionImage = "arrow.up.left.circle.fill"
            print(windDirectionImage)
            
        case "NNW":
            windDirectionImage = "arrow.up.left.circle.fill"
            print(windDirectionImage)
            
        default:
            windDirectionImage = "circle.fill"
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
        
        ifLocationIsntEnabledLabel.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingView.alpha = 0
            self.loadingLabel.alpha = 0
        })
        showSubviewsAfterLoading()
    }
    
    //----------------------------------------------
    func setupForecastTableView() {
        forecastTableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height / 1.3)
        forecastTableView.separatorStyle = .singleLine
        
    }
    
    func setupForecastBackgroundView() {
        forecastBackgroundView.backgroundColor = .black.withAlphaComponent(0.9)
        forecastBackgroundView.anchor(top: view.topAnchor,
                                      bottom: view.bottomAnchor,
                                      leading: view.leadingAnchor,
                                      trailing: view.trailingAnchor,
                                      paddingTop: 0,
                                      paddingBottom: 0,
                                      paddingLeft: 0,
                                      paddingRight: 0)
    }
    
    //----------------------------------------------
    
    func fetchWeather(searchTerm: String) {
        WeatherController.shared.fetchWeather(searchTerm: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let numbers):
                    print(numbers)
                    self.cTemp = numbers.current.temp_c
                    self.fTemp = numbers.current.temp_f
                    self.cFeelsLike = numbers.current.feelslike_c
                    self.fFeelsLike = numbers.current.feelslike_f
                    self.humidity = numbers.current.humidity
                    self.windKph = numbers.current.wind_kph
                    self.windMph = numbers.current.wind_mph
                    self.windDirection = numbers.current.wind_dir
                    self.cityName = numbers.location.name
                    self.weatherIconString = numbers.current.condition.text
                    self.setupViews()
                    
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    func fetchForecast(searchTerm: String) {
        WeatherController.shared.fetchForcast(searchTerm: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let ForecastWeatherNumbers):
                    
                    for date in ForecastWeatherNumbers {
                        let date = date.date
                        self.forecastDates.append(date)
                    }
                    
                    for day in ForecastWeatherNumbers {
                        let number = day.day
                        self.forecastHighCTemp.append(number.maxtemp_c)
                        self.forecastHighFTemp.append(number.maxtemp_f)
                        self.forecastLowCTemp.append(number.mintemp_c)
                        self.forecastLowFTemp.append(number.mintemp_f)
                    }
                    
                    for icon in ForecastWeatherNumbers{
                        let iconString = icon.day.condition.text
                        self.forecastIconString.append(iconString)
                    }
                    
                    print("------------------------THIS IS THE FORCAST NUMBERS \(ForecastWeatherNumbers) ---------------------------")
                    
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationManager.stopUpdatingLocation()
        let latAndLong = "\(locValue.latitude),\(locValue.longitude)"
        locationLatAndLong = latAndLong
        self.callUsersLocation()
    }
    
    func callUsersLocation() {
        guard locationLatAndLong != nil else {return}
        locationManager.stopUpdatingLocation()
        searchTerm = locationLatAndLong
        
        if fetchWeatherBool == false {
            fetchWeatherBool = true
            fetchWeather(searchTerm: searchTerm!)
        }
        
        if fetchForecastBool == false {
            fetchForecastBool = true
            fetchForecast(searchTerm: searchTerm!)
        }
    }
    
    @objc func searchButtonPressed() {
        if searchBarTF.text?.isEmpty ?? true {
            print("tf is empty")
        } else {
            searchTerm = self.searchBarTF.text
            fetchWeather(searchTerm: searchTerm!)
            forecastDates.removeAll()
            forecastHighCTemp.removeAll()
            forecastHighFTemp.removeAll()
            forecastLowCTemp.removeAll()
            forecastLowFTemp.removeAll()
            forecastIconString.removeAll()
            fetchForecast(searchTerm: searchTerm!)
            locationManager.stopUpdatingLocation()
            forecastTableView.reloadData()
        }
    }
    
    @objc func forecastButtonPressed() {
        setupForecastBackgroundView()
        setupForecastTableView()
        
        forecastBackgroundView.alpha = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {self.forecastBackgroundView.alpha = 0.8
            self.forecastTableView.frame = CGRect(x: self.view.frame.width / 20, y: self.view.frame.height - self.view.frame.height / 1.3, width: self.view.frame.width - self.view.frame.width / 10, height: self.view.frame.height / 1.2)
        },
                       completion: nil)
    }
    
    @objc func forecastBackgroundViewPressed() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {self.forecastBackgroundView.alpha = 0
            self.forecastTableView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height / 1.3)
        },
                       completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}//End of class

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let _view = UIView()
        let lbl = UILabel()
        
        lbl.text = "forecast"
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.font = UIFont(name: weatherStrings.avenirBook, size: 36)
        lbl.frame = CGRect(x: 16, y: _view.frame.height / 2, width: view.frame.width, height: 50)
        lbl.clipsToBounds = true
        
        _view.addSubview(lbl)
        _view.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green3)
        return _view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastLowFTemp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell else {return UITableViewCell()}
        
        let highC = forecastHighCTemp[indexPath.row]
        let highF = forecastHighFTemp[indexPath.row]
        let lowC = forecastLowCTemp[indexPath.row]
        let lowF = forecastLowFTemp[indexPath.row]
        let iconString = forecastIconString[indexPath.row]
        let _day = forecastDates[indexPath.row]
        
        cell.setHighNumbers(cTemp: highC, fTemp: highF)
        cell.setLowNumbers(cTemp: lowC, fTemp: lowF)
        cell.setWeatherIcon(iconString: iconString)
        cell.setDayLabel(day: _day)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}//End of extension

extension WeatherViewController: cellUpdate {}
