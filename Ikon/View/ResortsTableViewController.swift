//
//  ResortsTableViewController.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 3/4/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit
import CoreLocation

class ResortsTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{

    var locationManager: CLLocationManager?
    @IBOutlet weak var mytable: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return User.myUser.userResorts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var total = 0
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResortRating", for: indexPath) as? ResortRatingCells
        let selected_resort = User.myUser.userResorts[indexPath.row]
        
        cell?.resortName.text = "RESORT NAME: " + selected_resort.name
        if(selected_resort.website.prefix(1) == "h")
        {
            cell?.durationSkied.text = selected_resort.website
        }
        else
        {
            cell?.durationSkied.text = "Website Unavailable"
        }
        for item in User.myUser.visitedResorts
        {
            if(item.name == selected_resort.name)
            {
                total += 1
            }
        }
        cell?.verticalFeet.text = String(total)
        return cell!
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        sortTable()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        sortTable()
        //self.mytable.beginUpdates()
        self.mytable.reloadData()
    }
    func sortTable()
    {
        User.myUser.userResorts.sort {$0.distanceCalc(long: (self.locationManager?.location?.coordinate.longitude)!, lat: (self.locationManager?.location?.coordinate.latitude)!) < $1.distanceCalc(long: (self.locationManager?.location?.coordinate.longitude)!, lat: (self.locationManager?.location?.coordinate.latitude)!) }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowWeatherList"
        {
            let destVC = segue.destination as! ResortViewController
            let selectedIndexPath = mytable.indexPathForSelectedRow
            let currentresort = User.myUser.userResorts[(selectedIndexPath?.row)!]
            destVC.ikonResort = currentresort
        }
    }
    
}
