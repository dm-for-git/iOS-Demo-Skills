//
//  WeatherCell.swift
//  MetaWeather
//
//  Created by DavidMartin on 8/6/21.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    var weather: Weather? {
        didSet {
            loadWeatherIconBy(iconCode: weather?.iconCode ?? "")
            
            lblWeatherState.text = (weather?.status ?? "").capitalized
            
            let currentTemp = NSString(format:"\(Int(weather?.currentTemp ?? 0))%@C" as NSString, "\u{00B0}") as String
            lblCurrentTemp.text = currentTemp
            
            let maxTemp = NSString(format:"H: \(Int(weather?.maxTemp ?? 0))%@C" as NSString, "\u{00B0}") as String
            lblMaxTemp.text = maxTemp
            
            let minTemp = NSString(format:"L: \(Int(weather?.minTemp ?? 0))%@C" as NSString, "\u{00B0}") as String
            lblMinTemp.text = minTemp
            
            lblCityName.text = weather?.cityName ?? "Unavailable"
        }
    }
    
    private lazy var isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgWeatherState: ImageLoaderView!
    @IBOutlet weak var lblWeatherState: UILabel!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Create card based cell
        containerView.layer.cornerRadius = 10.0
        containerView.layer.borderColor  =  UIColor.clear.cgColor
        containerView.layer.borderWidth = 5.0
        containerView.layer.masksToBounds = true
        
        self.layer.shadowColor =  UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.containerView.layer.cornerRadius).cgPath
    }
    
    private func loadWeatherIconBy(iconCode: String) {
        /**
         * To get weather status icon by weather status code
         https://openweathermap.org/img/wn/<icon code goes here>@2x.png
         */
        guard iconCode != ""  else { return }
        let iconUrl = Constants.apiIcon + iconCode + "@2x.png"
        imgWeatherState.load(strUrl: iconUrl)
    }
    
    private func setUpdateTimeBy(timeString: String) {
        // Updated at
        let actualDate = isoDateFormatter.date(from: timeString)
        
        if let newDate = actualDate {
            let dateFormatter = DateFormatter()
            let currentTimeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.timeZone = currentTimeZone
            dateFormatter.dateFormat = "HH:mm"
            lblCityName.text = "\(String.stringByKey(key: .cellTimeLabel)) \(dateFormatter.string(from: newDate))"
        }
    }
    
}
