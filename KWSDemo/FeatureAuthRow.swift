//
//  AuthTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureAuthRow: UITableViewCell {
    
    @IBOutlet weak var authTitle: UILabel!
    @IBOutlet weak var authMessage: UILabel!
    @IBOutlet weak var authActionButton: KWSBlueButton!
    @IBOutlet weak var authDocsButton: KWSBlueButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        authTitle.text = "page_features_row_auth_title".localized
        authMessage.text = "page_features_row_auth_content".localized
        authActionButton.setTitle("page_features_row_auth_button_login_not_logged".localized.uppercased(), for: UIControlState())
        authDocsButton.setTitle("page_features_row_auth_button_doc".localized.uppercased(), for: UIControlState())
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
