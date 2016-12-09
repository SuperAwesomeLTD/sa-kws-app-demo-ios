//
//  NotifTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureNotifRow: UITableViewCell {

    @IBOutlet weak var notifTitle: UILabel!
    @IBOutlet weak var notifMessage: UILabel!
    @IBOutlet weak var notifEnableOrDisableButton: KWSBlueButton!
    @IBOutlet weak var notifDocButton: KWSBlueButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        notifTitle.text = "feature_cell_notif_title".localized
        notifMessage.text = "feature_cell_notif_content".localized
        notifEnableOrDisableButton.setTitle("feature_cell_notif_button_1_enable".localized.uppercased(), for: UIControlState())
        notifDocButton.setTitle("feature_cell_notif_button_2".localized.uppercased(), for: UIControlState())
    }
}
