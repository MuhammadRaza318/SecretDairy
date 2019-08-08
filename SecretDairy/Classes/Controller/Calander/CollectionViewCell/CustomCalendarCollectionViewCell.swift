//
//  CustomCalendarCollectionViewCell.swift
//  SecretDairy
//
//  Created by Muhammad Luqman on 12/28/17.
//  Copyright © 2017 Muhammad Luqman. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCalendarCollectionViewCell: JTAppleCell {
    
    @IBOutlet var datelabel: UILabel!
    @IBOutlet var selectedCell: UIView!
    @IBOutlet var viewForBackground: UIView!
    @IBOutlet var viewForNotification: UIView!
    
}
