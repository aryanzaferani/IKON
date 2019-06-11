//
//  addFriendsViewController.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 6/5/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit

class addFriendsViewController: UIViewController
{

    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    var user : OtherUsers?
    var DB = PopulateFirebase.myDB
    
    override func viewDidLoad()
        
    {
        super.viewDidLoad()
        acceptButton.layer.cornerRadius = 10
        acceptButton.layer.borderWidth = 0
        acceptButton.layer.borderColor = UIColor.black.cgColor
        
        rejectButton.layer.cornerRadius = 10
        rejectButton.layer.borderWidth = 0
        rejectButton.layer.borderColor = UIColor.black.cgColor
        
        username.text = user!.username
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let profileurl = user!.profilepic?.replacingOccurrences(of: ",", with: ".")
        let url = URL(string: profileurl!)
        let data = try? Data(contentsOf: url!)
        userImage.image = UIImage(data: data!)
        
        username.text = user!.name
    }
    

    @IBAction func acceptFriend(_ sender: Any)
    {
        DB.acceptFriend(user: user!)
    }
    @IBAction func rejectFriend(_ sender: Any)
    {
        DB.removeFriend(user: user!)
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
