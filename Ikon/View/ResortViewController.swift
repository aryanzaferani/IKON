//
//  ResortViewController.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 3/4/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit
import GoogleMaps


class ResortViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate
{

    @IBOutlet weak var twentyFourLabel: UILabel!
    
    @IBOutlet weak var fourtyEightLabel: UILabel!
    var ikonResort : Resorts?
    var apiString5DayForecast: String = ""
    var pastSnow: String = ""
    var weather: [Forecast.Period] = []
    var pastWeather: [Forecast.Period] = []
    var locationManager: CLLocationManager?
    var previousAlt = 0.0
    @IBOutlet weak var resortName: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mytable: UITableView!
    var items: [Weather] = []
    var items_past: [Weather] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        apiString5DayForecast.append("https://api.openweathermap.org/data/2.5/forecast?lat=")
        apiString5DayForecast.append(String((ikonResort?.latitude)!))
        apiString5DayForecast.append("&lon=")
        apiString5DayForecast.append(String((ikonResort?.longitude)!))
        pastSnow = apiString5DayForecast
        pastSnow.append("&type=hour&start=")
        pastSnow.append(String(Int((NSDate().timeIntervalSince1970)) - 172800))
        pastSnow.append("&end=")
        pastSnow.append(String(NSDate().timeIntervalSince1970))
        pastSnow.append("&units=imperial&appid=98a7ebb4c90d394062e50287152750a5")
        apiString5DayForecast.append("&units=imperial&appid=98a7ebb4c90d394062e50287152750a5")
        resortName.text = ikonResort?.name
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: apiString5DayForecast)!)
        let task: URLSessionDataTask = session.dataTask(with: request)
        { (receivedData, response, error) -> Void in
            if let data = receivedData
            {
                do
                {
                    let decoder = JSONDecoder()
                    let datatext = try decoder.decode(Forecast.self, from: data)
                    self.weather = datatext.list
                    self.processWeather()
                    
                    // Will run in the main thread. You can only update the UI in the main thread
                    DispatchQueue.main.async
                    {
                        self.mytable.reloadData()

                    }
                } catch
                {
                    print("Exception on Decode: \(error)")
                }
            }
        }
        task.resume()
        
        let session2 = URLSession(configuration: URLSessionConfiguration.default)
        let request2 = URLRequest(url: URL(string: pastSnow)!)
        let task2: URLSessionDataTask = session2.dataTask(with: request2)
        { (receivedData, response, error) -> Void in
            if let data = receivedData
            {
                do
                {
                    let decoder = JSONDecoder()
                    let datatext = try decoder.decode(Forecast.self, from: data)

                    self.pastWeather = datatext.list
                    for period in self.pastWeather
                    {
                        self.items_past.append(Weather(dateAndTimeAsUnixTime: period.dt, conditions: period.weather[0].description, highTemp: period.main.temp_max, lowTemp: period.main.temp_min, windSpeed: period.wind.speed, windDirection: period.wind.deg, humidity: period.main.humidity, iconID: period.weather[0].icon,snow: period.snow?.threeHour ?? 0.0))
                    }
                    // Will run in the main thread. You can only update the UI in the main thread
                    DispatchQueue.main.async
                        {
                            self.mytable.reloadData()
                            
                    }
                } catch
                {
                    print("Exception on Decode: \(error)")
                }
            }
        }
        task2.resume()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        let camera = GMSCameraPosition.camera(withLatitude: ikonResort!.latitude, longitude: ikonResort!.longitude, zoom: 15)
        let map = GMSMapView.map(withFrame: (self.view.bounds), camera: camera)
        map.isMyLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(ikonResort!.latitude, ikonResort!.longitude)
        marker.map = mapView
        self.mapView?.addSubview(map)
        stopButton.isHidden = true
        getSnow()
    }
    func getSnow()
    {
        var twentyfourhour = 0.0
        var fourtyeighthour = 0.0
        for item in 0..<8 where (item < items_past.count)
        {
            twentyfourhour += (items_past[item].snow * 0.0393701)
        }
        for item in 0..<16 where (item < items_past.count)
        {
            fourtyeighthour += (items_past[item].snow * 0.0393701)
        }
        fourtyEightLabel.text = "48HR: " + String(fourtyeighthour) + "in"
        twentyFourLabel.text = "24HR: " + String(twentyfourhour) + "in"
    }
    func processWeather()
    {
        for period in weather
        {
            items.append(Weather(dateAndTimeAsUnixTime: period.dt, conditions: period.weather[0].description, highTemp: period.main.temp_max, lowTemp: period.main.temp_min, windSpeed: period.wind.speed, windDirection: period.wind.deg, humidity: period.main.humidity, iconID: period.weather[0].icon, snow: period.snow?.threeHour ?? 0.0))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! WeatherCell
        let item = items[indexPath.row]
        cell.date.text = item.dateAndTime
        cell.conditions.text = item.conditions
        cell.hightemp.text = String(item.highTemp) + "°F"
        cell.lowtemp.text = String(item.lowTemp) + "°F"
        cell.windspeed.text = String(item.windSpeed) + "mph"
        return cell
        
    }
    
    @IBAction func startResort(_ sender: UIButton)
    {
        if(sender.tag == 0)
        {
            let resort = Resorts(id: (ikonResort?.id)!, name: (ikonResort?.name)!, region: (ikonResort?.region)!, longitude: (ikonResort?.longitude)!, latitude: (ikonResort?.latitude)!, skied: true, vertical_feet_skied: 0, highest_point: Int(Double(1.0)), base: Int(Double(0.0)), time_spent: 0, temp: 0, lat: [], long: [], date: Int(NSDate().timeIntervalSince1970), weather: [],website: (ikonResort?.website)!)
            ikonResort = resort
            locationManager?.startUpdatingLocation()
            User.myUser.visitedResorts.append(resort)
            startButton.isHidden = true
            stopButton.isHidden = false
            navigationItem.hidesBackButton = true
        }
        
    }
    
    @IBAction func stopResort(_ sender: UIButton)
    {
        if(sender.tag == 1)
        {
            for item in User.myUser.visitedResorts
            {
                if(item == ikonResort)
                {
                    item.skied = false
                    item.time_spent = Double(NSDate().timeIntervalSince1970) - Double(item.date)
                    let encodedData = try! JSONEncoder().encode(User.myUser)
                    UserDefaults.standard.set(encodedData, forKey: "USER")
                    navigationItem.hidesBackButton = false
                }
            }
            locationManager?.stopUpdatingLocation()
            stopButton.isHidden = true
            startButton.isHidden = false
            
        }
        
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        if let location = locations.last
        {
            if(location.altitude < previousAlt)
            {
                startTracking(location: location, feet: previousAlt - location.altitude)
            }
            else
            {
                startTracking(location: location, feet: 0)
            }
            previousAlt = location.altitude
        }
    }
    
    func startTracking(location: CLLocation, feet: Double)
    {
        for item in User.myUser.visitedResorts
        {
            if(item == ikonResort)
            {
                item.lat.append(location.coordinate.latitude)
                item.long.append(location.coordinate.longitude)
                item.vertical_feet_skied = item.vertical_feet_skied + Int(Double(feet) * 3.28084)
                let encodedData = try! JSONEncoder().encode(User.myUser)
                UserDefaults.standard.set(encodedData, forKey: "USER")
            }
        }
        
    }
  

}
