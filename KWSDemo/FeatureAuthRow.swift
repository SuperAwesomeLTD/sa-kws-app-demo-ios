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
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var authActionButton: UIButton!
    @IBOutlet weak var authDocsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        content.addShadow()
        
        authTitle.text = "feature_cell_auth_title".localized
        authMessage.text = "feature_cell_auth_content".localized
        authActionButton.setTitle("feature_cell_auth_button_1_loggedout".localized.uppercaseString, forState: UIControlState.Normal)
        authDocsButton.setTitle("feature_cell_auth_button_2".localized.uppercaseString, forState: UIControlState.Normal)
        
        authActionButton.blueButton()
        authDocsButton.blueButton()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
