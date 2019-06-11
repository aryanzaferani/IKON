//
//  MyResortsCells.swift
//  Lab_5
//
//  Created by Aryan Zaferani-Nobari on 2/5/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit

class MyResortsCells: UITableViewCell
{
    
    @IBOutlet weak var resortName: UILabel!
    @IBOutlet weak var durationSkied: UILabel!
    @IBOutlet weak var verticalFeet: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
