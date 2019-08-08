//
//  FontTableViewCell.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 12/27/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

import UIKit

class FontTableViewCell: UITableViewCell {

    @IBOutlet var labelForText: UILabel!
    @IBOutlet var imageForIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
