//
//  SettingTableViewCell.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 12/27/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    
    
    @IBOutlet var labelForTitle: UILabel!
    @IBOutlet var labelForDetail: UILabel!
    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var outletSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
