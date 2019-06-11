//
//  UserViewController.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 3/3/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit
import GoogleSignIn

class UserViewController: UIViewController
{
  

    @IBOutlet weak var myProfile: UIButton!
    @IBOutlet weak var myFriends: UIButton!
    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var Logo: UIImageView!
    
    let DB = PopulateFirebase.myDB
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        buttonSetup()
        DB.getUsers()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute:
            {
                self.DB.getMyUser()
                self.checkUserPresent()
            // Put your code which should be executed with a delay here
        })
        //DB.populateResortDB()
        

    }
    
    func checkUserPresent()
    {
        var present = false
        for user in DB.users
        {
            let fixeduser = User.myUser.username?.replacingOccurrences(of: ".", with: ",")
            if user.username == fixeduser
            {
                present = true
                break
            }
        }
        if(present == false)
        {
            DB.addNewUserToDB(user: User.myUser)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        DB.getUsers()
    }
    
    
    func buttonSetup()
    {
        myProfile.layer.cornerRadius = 10
        myProfile.layer.borderWidth = 0
        myProfile.layer.borderColor = UIColor.black.cgColor
        signOut.layer.cornerRadius = 10
        signOut.layer.borderWidth = 0
        signOut.layer.borderColor = UIColor.black.cgColor
        myFriends.layer.cornerRadius = 10
        myFriends.layer.borderWidth = 0
        myFriends.layer.borderColor = UIColor.black.cgColor
    }
    
    
    @IBAction func unwindFromUserSegue(sender: UIStoryboardSegue)
    {
        
    }
    
    @IBAction func signOut(_ sender: Any)
    {
        GIDSignIn.sharedInstance().signOut()
        let encodedData = try! JSONEncoder().encode(User.myUser)
        UserDefaults.standard.set(encodedData, forKey: "USER")
        //UserDefaults.standard.removeObject(forKey: "USER")
        //GIDSignIn.sharedInstance()?.disconnect()
        
    }
    
  
}
