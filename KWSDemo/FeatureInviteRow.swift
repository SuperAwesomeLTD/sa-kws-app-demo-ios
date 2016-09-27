//
//  FeatureInviteRow.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureInviteRow: UITableViewCell {

    @IBOutlet weak var inviteTitle: UILabel!
    @IBOutlet weak var invMessage: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var invInviteFriendButton: UIButton!
    @IBOutlet weak var invSeeDocsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inviteTitle.text = "feature_cell_inv_title".localized
        invMessage.text = "feature_cell_inv_message".localized
        invInviteFriendButton.setTitle("feature_cell_inv_button_1".localized.uppercased(), for: UIControlState())
        invSeeDocsButton.setTitle("feature_cell_inv_button_2".localized.uppercased(), for: UIControlState())
        
        content.addShadow()
        invInviteFriendButton.blueButton()
        invSeeDocsButton.blueButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
