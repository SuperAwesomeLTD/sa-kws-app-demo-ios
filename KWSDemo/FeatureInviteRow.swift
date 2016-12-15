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
    @IBOutlet weak var invInviteFriendButton: KWSBlueButton!
    @IBOutlet weak var invSeeDocsButton: KWSBlueButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inviteTitle.text = "page_features_row_invite_title".localized
        invMessage.text = "page_features_row_invite_content".localized
        invInviteFriendButton.setTitle("page_features_row_invite_button_invite".localized.uppercased(), for: UIControlState())
        invSeeDocsButton.setTitle("page_features_row_invite_button_doc".localized.uppercased(), for: UIControlState())
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
