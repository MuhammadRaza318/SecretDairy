//
//  SearchTableViewCell.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 1/5/18.
//  Copyright © 2018 Muhammad Luqman. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet var labelForDate: UILabel!
    @IBOutlet var labelForText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
