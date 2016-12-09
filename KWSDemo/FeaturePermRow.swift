//
//  PermTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 10/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeaturePermRow: UITableViewCell {

    @IBOutlet weak var permTitle: UILabel!
    @IBOutlet weak var permMessage: UILabel!
    @IBOutlet weak var permAddPermissionsButton: KWSBlueButton!
    @IBOutlet weak var permSeeDocsButton: KWSBlueButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        permTitle.text = "feature_cell_perm_title".localized
        permMessage.text = "feature_cell_perm_content".localized
        permAddPermissionsButton.setTitle("feature_cell_perm_button_1".localized.uppercased(), for: UIControlState())
        permSeeDocsButton.setTitle("feature_cell_perm_button_2".localized.uppercased(), for: UIControlState())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
