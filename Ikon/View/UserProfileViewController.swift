//
//  UserProfileViewController.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 3/3/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: UIImageView!
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return User.myUser.visitedResorts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyResorts", for: indexPath) as? MyResortsCells
        let selected_resort = User.myUser.visitedResorts[indexPath.row]
        cell?.resortName.text = "RESORT NAME: " + selected_resort.name
        cell?.durationSkied.text = "DATE SKIED: " + String(df.string(from: NSDate(timeIntervalSince1970: TimeInterval(selected_resort.date)) as Date))
        cell?.verticalFeet.text = String(selected_resort.vertical_feet_skied) + "FT"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == .delete) {
            User.myUser.visitedResorts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            let encodedData = try! JSONEncoder().encode(User.myUser)
            UserDefaults.standard.set(encodedData, forKey: "USER")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier
        {
            switch(id)
            {
            case "Resort":
                let navC = segue.destination as? UINavigationController
                let destVC = navC?.topViewController as? UserResortViewController
                let selectedIndexPath = tableView.indexPathForSelectedRow
                let currentresort = User.myUser.visitedResorts[(selectedIndexPath?.row)!]
                destVC?.resort = currentresort
                
            default:
                fatalError()
            }
        }
    }
    
    @IBAction func unwindFromUserResortSegue(sender: UIStoryboardSegue)
    {
        
    }


    override func viewDidLoad()
    {
        super.viewDidLoad()
        username.text = User.myUser.name
        var profilepic = (User.myUser.profilepic?.replacingOccurrences(of: ",", with: "."))
        
        let url = URL(string:profilepic!)
        let data = try? Data(contentsOf: url!)
        userImage.image = UIImage(data: data!)

    }
 
}
