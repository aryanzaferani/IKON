//
//  UserResortViewController.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 3/3/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit
import GoogleMaps

class UserResortViewController: UIViewController
{
    var resort: Resorts!
    var locationManager = CLLocationManager()
    //let path = GMSMutablePath()
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var verticalfeet: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        if(resort.skied == false)
        {
            let formatted = formatter.string(from: resort.time_spent) ?? ""
            duration.text = "SKIED FOR: " + formatted
        }
        else
        {
            duration.text = ""
        }
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        date.text = df.string(from: Date(timeIntervalSince1970: Double(resort.date)))
        
        
    }
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: resort.latitude, longitude: resort.longitude, zoom: 15)
        verticalfeet.text = "VERTICAL FEET SKIED: " + String(resort!.vertical_feet_skied) + "FT"
        name.text = resort!.name
        city.text = "REGION: " + resort!.region
        duration.text = "DURATION: " + String(resort.id)
        let map = GMSMapView.map(withFrame: (self.view.bounds), camera: camera)
        map.isMyLocationEnabled = true
        let path = GMSMutablePath()
        
        for i in 0..<resort.lat.count
        {
            path.add(CLLocationCoordinate2D(latitude: resort.lat[i], longitude: resort.long[i]))
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .black
        polyline.strokeWidth = 5.0
        polyline.map = map
        
        self.mapView?.addSubview(map)
        
        // Do any additional setup after loading the view.
    }
  
}
