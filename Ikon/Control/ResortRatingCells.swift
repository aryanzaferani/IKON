//
//  ResortRatingCells.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 3/4/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import Foundation
import UIKit

class ResortRatingCells: UITableViewCell
{
    
    @IBOutlet weak var currentWeatherImage: UIImageView!
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
