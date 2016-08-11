//
//  NotifTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureNotifRow: UITableViewCell {

    @IBOutlet weak var content: UIView!
    @IBOutlet weak var notifEnableOrDisableButton: UIButton!
    @IBOutlet weak var notifDocButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.addShadow()
        notifEnableOrDisableButton.blueButton()
        notifDocButton.blueButton()
    }
}
