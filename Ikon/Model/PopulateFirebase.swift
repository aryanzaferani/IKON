//
//  PopulateFirebase.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 6/3/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

protocol MyDelegate
{
    func didFetchData(data:[String])
}

final class PopulateFirebase
{
    
    static var myDB = PopulateFirebase()
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("savedData")
    var ikonResorts : [Resorts] = []
    var resort_names = [String]()
    var ikon_names: [String] = []
    var skimapAPI: String = "https://skimap.org/SkiAreas/index.json"
    var skiResorts : [SkiMapResorts.SkiRegion] = []
    var databaseRef:  DatabaseReference?
    var resorts = [Resorts]()
    var users = [OtherUsers]()
    var friend = OtherUsers(name: "", username: "", pendingFriends: [], acceptedFriends: [], long: 0.0, lat: 0.0, profilepic: "")
    
    
    func setUpDB()
    {
        Database.database().isPersistenceEnabled = true
        databaseRef = Database.database().reference()
        databaseRef?.keepSynced(true)
    }
    func populateResortDB()
    {-
        setUpDB()
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: skimapAPI)!)
        if let url = Bundle.main.url(forResource:"Resorts", withExtension: "plist")
        {
            do
            {
                let data = try Data(contentsOf:url)
                ikon_names = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String]
            }
            catch
            {
                print(error)
            }
        }
        let task: URLSessionDataTask = session.dataTask(with: request)
        { (receivedData, response, error) -> Void in
            if let data = receivedData
            {
                do
                {
                    let decoder = JSONDecoder()
                    let datatext = try decoder.decode([SkiMapResorts.SkiRegion].self, from: data)
                    self.skiResorts = datatext
                    self.processResorts()
                }
                catch
                {
                    print("Exception on Decode: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func getResortsFromDB()
    {
        self.resorts = []
        setUpDB()
        databaseRef?.child("Resorts").queryOrdered(byChild: "Resorts").observe(.value, with:
            { snapshot in
                
                for item in snapshot.children.allObjects as! [DataSnapshot]
                {
                    guard let restDict = item.value as? [String: Any] else { continue }
                    self.resorts.append(Resorts(id: restDict["id"] as! Int, name: restDict["name"] as! String, region: restDict["region"] as! String, longitude: restDict["longitude"] as! Double, latitude: restDict["latitude"] as! Double, skied: false, vertical_feet_skied: 0, highest_point: 0, base: 0, time_spent: 0.0, temp: 0.0, lat: [], long: [], date: 0, weather: [], website: restDict["website"] as! String))
                }
        })
    }
    
    func processResorts()
    {
        for item in skiResorts
        {
            if ikon_names.contains(item.SkiArea.name ?? " ")
            {
                ikonResorts.append(Resorts(id: Int(item.SkiArea.id ?? " ")!, name: item.SkiArea.name ?? " ", region: item.Region[0].name ?? "Unavailable", longitude: Double(item.SkiArea.geo_lng!) ?? 0.0, latitude: Double(item.SkiArea.geo_lat!) ?? 0.0, skied: false, vertical_feet_skied: 0, highest_point: Int(1.0), base: 2, time_spent: 0.0, temp: 0.0, lat: [], long: [],date: 0, weather: [],website: item.SkiArea.official_website ?? ""))
                let newResortRef = databaseRef?.child("Resorts").child(ikonResorts.last!.name)
                newResortRef?.setValue(ikonResorts.last!.toAnyObject())
            }
        }
    }
    
    
    
    func addNewUserToDB(user: User)
    {
        user.acceptedFriends = [" "]
        user.pendingFriends = [" "]
        let username = user.username?.replacingOccurrences(of: ".", with: ",")
        let newResortRef = databaseRef?.child("Users").child(username!)
        newResortRef?.setValue(user.toAnyObject())
        
    }
    
    func getUsers()
    {
        //Database.database().isPersistenceEnabled = true
        self.users = []
        var array = [OtherUsers]()
        var usertemp = OtherUsers(name: "", username: "", pendingFriends: [], acceptedFriends: [], long: 0.0, lat: 0.0, profilepic: "")
        databaseRef?.child("Users").queryOrdered(byChild: "Users").observeSingleEvent(of: .value, with:
            { snapshot in

                for item in snapshot.children.allObjects as! [DataSnapshot]
                {
                    guard let restDict = item.value as? [String: Any] else { continue }
                    usertemp = (OtherUsers(name: restDict["name"] as! String , username: restDict["username"] as! String, pendingFriends: restDict["pendingFriends"] as! [String], acceptedFriends: restDict["acceptedFriends"] as! [String], long: restDict["long"] as! Double, lat: restDict["lat"] as! Double, profilepic: restDict["profilepic"] as! String))
                    array.append(usertemp)
                }
                self.users = array
        })
        
    }
    
    
    func updateLocations(user : User, long : Double, lat :Double)
    {
        user.lat = lat
        user.long = long
        let newWordRef = databaseRef?.child("Users").child(user.username!)
        newWordRef?.removeValue()
        newWordRef?.setValue(user.toAnyObject())
    }
    
//    func updateUsers(user: OtherUsers)
//    {
//        let newWordRef = databaseRef?.child("Users").child(user.username!)
//        newWordRef?.removeValue()
//        print(user.toAnyObject())
//        newWordRef?.setValue(user.toAnyObject())
//    }
    func acceptFriend(user: OtherUsers)
    {
        var username = ""
        if let index = User.myUser.pendingFriends.index(of: user.username!)
        {
            username = User.myUser.pendingFriends.remove(at: index)
        }
        for item in self.users
        {
            if item.username == user.username
            {
                item.acceptedFriends.append(User.myUser.username!)
                updateAcceptedList(user: item)
                break
            }
        }
        
        
        //User.myUser.acceptedFriends.append(username)
        updateMyUser()
    }
    
    func removeFriend(user: OtherUsers)
    {
        if let index = User.myUser.pendingFriends.index(of: user.username!)
        {
            User.myUser.pendingFriends.remove(at: index)
        }
        updateMyUser()
    }
    
    
    func updateAcceptedList(user: OtherUsers)
    {
        let newWordRef = databaseRef?.child("Users").child(user.username!).child("acceptedFriends")
        newWordRef?.setValue(user.acceptedFriends)
        
    }
    
    func updatePendingList(user: OtherUsers)
    {
        let newWordRef = databaseRef?.child("Users").child(user.username!).child("pendingFriends")
        newWordRef?.setValue(user.pendingFriends)
        
    }
    
    func updateMyUser()
    {
        let newWordRef = databaseRef?.child("Users").child(User.myUser.username!)
        newWordRef?.removeValue()
        newWordRef?.setValue(User.myUser.toAnyObject())
        let encodedData = try! JSONEncoder().encode(User.myUser)
        UserDefaults.standard.set(encodedData, forKey: "USER")
    }
    
    func getMyUser()
    {
        databaseRef?.child("Users").queryOrdered(byChild: "Users").observe(.value, with:
            { snapshot in
                
                for item in snapshot.children.allObjects as! [DataSnapshot]
                {
                    guard let restDict = item.value as? [String: Any] else { continue }
                    if(restDict["username"] as! String == User.myUser.username)
                    {
                        User.myUser.name = restDict["name"] as! String
                        User.myUser.username = restDict["username"] as! String
                        User.myUser.pendingFriends = restDict["pendingFriends"] as! [String]
                        User.myUser.acceptedFriends = restDict["acceptedFriends"] as! [String]
                        User.myUser.profilepic = restDict["profilepic"] as! String
                        User.myUser.long = restDict["long"] as! Double
                        User.myUser.lat = restDict["lat"] as! Double
                        let encodedData = try! JSONEncoder().encode(User.myUser)
                        UserDefaults.standard.set(encodedData, forKey: "USER")
                    }
                }
        })
    }
    
    func getAUser(user : String)
    {
        databaseRef?.child("Users").queryOrdered(byChild: "Users").observe(.value, with:
            { snapshot in
                
                for item in snapshot.children.allObjects as! [DataSnapshot]
                {
                    guard let restDict = item.value as? [String: Any] else { continue }
                    if(restDict["username"] as! String == user)
                    {
                        self.friend.name = (restDict["name"] as! String)
                        self.friend.username = (restDict["username"] as! String)
                        self.friend.profilepic = (restDict["profilepic"] as! String)
                    }
                }
        })
    }
}

