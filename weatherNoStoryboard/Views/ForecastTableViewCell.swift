//
//  ForecastTableViewCell.swift
//  weatherNoStoryboard
//
//  Created by Jacob Schvaneveldt on 10/31/21.
//

import UIKit

protocol cellUpdate: AnyObject {}

class ForecastTableViewCell: UITableViewCell {
    
    //MARK: - VIEWS
    private let dayLabel: UILabel = {
        let lbl = UILabel()
        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let highVerticalSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        
        return sv
    }()
    
    private let highLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "high"
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.font = UIFont(name: weatherStrings.avenirLight, size: 16)
        lbl.textAlignment = .right

        
        return lbl
    }()
    
    private let highNumbersLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "highnumber"
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.font = UIFont(name: weatherStrings.avenirMedium, size: 16)
        lbl.textAlignment = .right

        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let lowVerticalSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        
        return sv
    }()
    
    private let lowLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "low"
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.font = UIFont(name: weatherStrings.avenirLight, size: 16)
        lbl.textAlignment = .left

        
        return lbl
    }()
    
    private let lowNumbersLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "lownubmer"
        lbl.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        lbl.font = UIFont(name: weatherStrings.avenirMedium, size: 16)
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    //----------------------------------------------
    
    private let weatherIcon: UIImageView = {
        let img = UIImageView()
        
        return img
    }()
    
    
    //MARK: - PROPERTIES
    static let identifier = "ForecastTableViewCell"
    weak var delegate: cellUpdate?    
    
    //viewDidLoad
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAllSubviews()
        contentView.backgroundColor = UIColor(named: weatherStrings.colorScheme1Green3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupDayLabel()
        setupWeatherIcon()
        setupLowVerticalSV()
        setupHighVerticalSV()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - FUNCTIONS
    func addAllSubviews() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(highVerticalSV)
        contentView.addSubview(lowVerticalSV)
    }
    
    func setHighNumbers(cTemp: Double, fTemp: Double) {

        let ctemp = cTemp
        let ftemp = fTemp
        highNumbersLabel.text = "\(Int(ctemp)) | \(Int(ftemp))"
    }

    func setLowNumbers(cTemp: Double, fTemp: Double) {
        let ctemp = cTemp
        let ftemp = fTemp
        lowNumbersLabel.text = "\(Int(ctemp)) | \(Int(ftemp))"
    }

    func setWeatherIcon(iconString: String) {
        var iconImageName = iconString
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
        
        weatherIcon.image = UIImage(named: iconImageName)
        print("iconimagename\(iconImageName)")
        weatherIcon.contentMode = .scaleAspectFill
        weatherIcon.contentMode = .scaleAspectFit
    }
    
    func setDayLabel(day: String) {
        dayLabel.text = day
    }
    
    func setupDayLabel() {
        dayLabel.textColor = UIColor(named: weatherStrings.colorScheme1Yellow)
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont(name: weatherStrings.avenirLight, size: 32)
        dayLabel.sizeToFit()
        dayLabel.anchor(top: contentView.topAnchor,
                        bottom: nil,
                        leading: contentView.leadingAnchor,
                        trailing: nil,
                        paddingTop: 0,
                        paddingBottom: 0,
                        paddingLeft: contentView.frame.width / 2 - dayLabel.frame.width / 2,
                        paddingRight: 0,
                        height: 32)
    }
    
    func setupHighVerticalSV() {
        contentView.addSubview(highLabel)
        contentView.addSubview(highNumbersLabel)
        
        highVerticalSV.anchor(top: dayLabel.bottomAnchor,
                              bottom: nil,
                              leading: weatherIcon.trailingAnchor,
                              trailing: nil,
                              paddingTop: 0,
                              paddingBottom: 0,
                              paddingLeft: 0,
                              paddingRight: 0,
                              width: 100,
                              height: 50)
        
        highLabel.anchor(top: highVerticalSV.topAnchor,
                         bottom: highNumbersLabel.topAnchor,
                         leading: highVerticalSV.leadingAnchor,
                         trailing: highVerticalSV.trailingAnchor,
                         paddingTop: 0,
                         paddingBottom: 0,
                         paddingLeft: 0,
                         paddingRight: 0)
        
        highNumbersLabel.anchor(top: highLabel.bottomAnchor,
                                bottom: highVerticalSV.bottomAnchor,
                                leading: highVerticalSV.leadingAnchor,
                                trailing: highVerticalSV.trailingAnchor,
                                paddingTop: 0,
                                paddingBottom: 0,
                                paddingLeft: 0,
                                paddingRight: 0)
    }
    
    func setupLowVerticalSV() {
        contentView.addSubview(lowLabel)
        contentView.addSubview(lowNumbersLabel)
        
        lowVerticalSV.anchor(top: dayLabel.bottomAnchor,
                             bottom: nil,
                             leading: contentView.leadingAnchor,
                             trailing: weatherIcon.leadingAnchor,
                             paddingTop: 0,
                             paddingBottom: 0,
                             paddingLeft: contentView.frame.width / 2 - lowVerticalSV.frame.width / 2 - weatherIcon.frame.width / 2 - highVerticalSV.frame.width / 2,
                             paddingRight: 0,
                             width: 100,
                             height: 50)
        
        lowLabel.anchor(top: lowVerticalSV.topAnchor,
                        bottom: lowNumbersLabel.topAnchor,
                        leading: lowVerticalSV.leadingAnchor,
                        trailing: lowVerticalSV.trailingAnchor,
                        paddingTop: 0,
                        paddingBottom: 0,
                        paddingLeft: 0,
                        paddingRight: 0)
        
        lowNumbersLabel.anchor(top: lowLabel.bottomAnchor,
                               bottom: lowVerticalSV.bottomAnchor,
                               leading: lowVerticalSV.leadingAnchor,
                               trailing: lowVerticalSV.trailingAnchor,
                               paddingTop: 0,
                               paddingBottom: 0,
                               paddingLeft: 0,
                               paddingRight: 0)
    }
    
    func setupWeatherIcon() {
        weatherIcon.anchor(top: dayLabel.bottomAnchor,
                           bottom: nil,
                           leading: lowVerticalSV.trailingAnchor,
                           trailing: highVerticalSV.leadingAnchor,
                           paddingTop: contentView.frame.height / 20,
                           paddingBottom: 0,
                           paddingLeft: 0,
                           paddingRight: 0,
                           width: 50,
                           height: 50)
    }

}
