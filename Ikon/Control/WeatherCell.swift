//
//  CustomCell.swift
//  Lab_6
//
//  Created by Aryan Zaferani-Nobari on 2/16/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var DateCaption: UILabel!
    @IBOutlet weak var LowTempCaption: UILabel!
    @IBOutlet weak var HighTempCaption: UILabel!
    @IBOutlet weak var ConditionsCaption: UILabel!
    @IBOutlet weak var WindSpeedCaption: UILabel!
    @IBOutlet weak var WindDirectionCaption: UILabel!
    @IBOutlet weak var HumidityCaption: UILabel!
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var lowtemp: UILabel!
    @IBOutlet weak var hightemp: UILabel!
    @IBOutlet weak var conditions: UILabel!
    @IBOutlet weak var windspeed: UILabel!
    @IBOutlet weak var winddirection: UILabel!
    @IBOutlet weak var humidity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
