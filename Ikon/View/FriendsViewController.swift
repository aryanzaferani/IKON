//
//  FriendsViewController.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 6/4/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit
import CoreLocation

class FriendsViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate
{
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var myFriendsHeader: UILabel!
    @IBOutlet weak var textFIeld: UITextField!
    @IBOutlet weak var table: UITableView!
    
    
    @IBOutlet weak var hide: UISwitch!
    
    
    var DB = PopulateFirebase.myDB
    var locationManager: CLLocationManager?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        submit.layer.cornerRadius = 10
        submit.layer.borderWidth = 0
        submit.layer.borderColor = UIColor.black.cgColor
        
        textFIeld.delegate = self
        DB.getUsers()
        self.table.reloadData()
        locationManager = CLLocationManager()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        DB.getMyUser()
        DB.getUsers()
        locationManager = CLLocationManager()
        self.table.reloadData()
    }
    
    @IBAction func toggle(_ sender: Any)
    {
        if(hide.isOn)
        {
            User.myUser.lat = -999
            User.myUser.long = -999
            DB.updateMyUser()
        }
        else
        {
            User.myUser.lat = locationManager?.location?.coordinate.latitude
            User.myUser.long = locationManager?.location?.coordinate.longitude
            DB.updateMyUser()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return User.myUser.pendingFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as? FriendCellTableViewCell
        let selected_friend = User.myUser.pendingFriends[indexPath.row]
        cell?.usernameLabel.text = selected_friend
        for item in DB.users
        {
            if item.username == selected_friend
            {
                let profileurl = item.profilepic?.replacingOccurrences(of: ",", with: ".")
                let url = URL(string: profileurl!)
                let data = try? Data(contentsOf: url!)
                cell?.userimage.image = UIImage(data: data!)
                break
            }
        }
        return cell!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textFIeld.resignFirstResponder()
        return true
    }
    

    @IBAction func submitPressed(_ sender: Any)
    {
       // DB.getUsers()
        var username = textFIeld.text
        username = username?.replacingOccurrences(of: ".", with: ",")
        for item in DB.users
        {
            if item.username == username
            {
                if(!item.pendingFriends.contains(User.myUser.username!))
                {
                    item.pendingFriends.append(User.myUser.username!)
                    DB.updatePendingList(user: item)
                }
                break
            }
        }
        textFIeld.resignFirstResponder()
        textFIeld.text = ""
    }
    
    @IBAction func unwindFromUserFriendsSegue(sender: UIStoryboardSegue)
    {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "confirmFriend"
        {
            let navC = segue.destination as? UINavigationController
            let destVC = navC?.topViewController as? addFriendsViewController
            let selectedIndexPath = table.indexPathForSelectedRow
            let friend = User.myUser.pendingFriends[(selectedIndexPath?.row)!]
            DB.getAUser(user: friend)
            destVC!.user = DB.friend
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
