//
//  GoogleSignIn.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 6/3/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import CoreLocation

class GoogleSignIn: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate
{
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    var DB = PopulateFirebase.myDB
    var resorts = [Resorts]()
    var locationManager: CLLocationManager?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        if(DB.resorts == [])
        {
            DB.getResortsFromDB()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        if(identifier == "NEWUSERCREATED")
        {
            if(User.myUser.name != "")
            {
                let encodedData = try! JSONEncoder().encode(User.myUser)
                UserDefaults.standard.set(encodedData, forKey: "USER")
                return true
            }
        }
        return false
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        
        if(UserDefaults.standard.object(forKey: "USER") == nil)
        {
            User.myUser.username = user.profile.email
            User.myUser.name = user.profile.givenName + " " + user.profile.familyName
            User.myUser.profilepic = user.profile.imageURL(withDimension: 500)?.absoluteString
            User.myUser.userResorts = DB.resorts
            User.myUser.lat = locationManager?.location?.coordinate.latitude
            User.myUser.long = locationManager?.location?.coordinate.longitude
            let encodedData = try! JSONEncoder().encode(User.myUser)
            UserDefaults.standard.set(encodedData, forKey: "USER")
        }
        else if(UserDefaults.standard.object(forKey: "USER") != nil)
        {
            do
            {
                let placeData = UserDefaults.standard.data(forKey: "USER")
                User.myUser  = try JSONDecoder().decode(User.self, from: placeData!)
            }
            catch
            {
                print(error)
            }
        }
        if(shouldPerformSegue(withIdentifier: "NEWUSERCREATED", sender: self))
        {
            performSegue(withIdentifier: "NEWUSERCREATED", sender: self)
        }

    }
    
    
    
}
