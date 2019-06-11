//
//  MapViewController.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 3/4/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var testLabel: UILabel!
    var selectedResort: Resorts?
    var selectedFriend: OtherUsers?
    
    var locationManager: CLLocationManager?
    var DB = PopulateFirebase.myDB
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        self.map.delegate =  self
        self.map.showsUserLocation = true
        for person in User.myUser.acceptedFriends
        {
            for temp in DB.users
            {
                if temp.username == person
                {
                    if(User.myUser.lat != -999)
                    {
                        map.addAnnotation(temp)
                    }
                }
            }
        }
        for item in User.myUser.userResorts
        {
            map.addAnnotation(item)
        }
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        updateCurrentLocation()
        // Do any additional setup after loading the view.
    }
    
        
    
    
    func updateCurrentLocation()
    {
        let center = CLLocationCoordinate2D(latitude: (locationManager?.location!.coordinate.latitude)!, longitude: (locationManager?.location!.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        if(User.myUser.long != -999)
        {
            User.myUser.long = (locationManager?.location!.coordinate.longitude)
            User.myUser.lat = (locationManager?.location!.coordinate.latitude)
        }
        DB.updateMyUser()
        self.map.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is Resorts
        {
            let annotationView = MKPinAnnotationView()
            annotationView.pinTintColor = .red
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.animatesDrop = false
            // add callout disclosure button
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
        
        if annotation is OtherUsers
        {
            let annotationView = MKPinAnnotationView()
            annotationView.pinTintColor = .blue
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.animatesDrop = false
            // add callout disclosure button
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
        
        
        return nil
    }

    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        for person in User.myUser.acceptedFriends
        {
            for temp in DB.users
            {
                if temp.username == person
                {
                    if(User.myUser.lat != -999)
                    {
                        map.addAnnotation(temp)
                    }
                }
            }
        }
        for item in User.myUser.userResorts
        {
            map.addAnnotation(item)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //DB.updateLocations(user: User.myUser, long: locationManager?.location?.coordinate.longitude ?? 0.0, lat: locationManager?.location?.coordinate.latitude ?? 0.0)
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        map.removeAnnotations(self.map.annotations)
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
