//
//  FriendCellTableViewCell.swift
//  Ikon
//
//  Created by Aryan Zaferani-Nobari on 6/4/19.
//  Copyright © 2019 Zaferani. All rights reserved.
//

import UIKit

class FriendCellTableViewCell: UITableViewCell
{

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userimage: UIImageView!
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
