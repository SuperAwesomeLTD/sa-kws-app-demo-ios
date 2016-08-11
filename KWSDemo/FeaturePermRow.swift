//
//  PermTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 10/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeaturePermRow: UITableViewCell {

    @IBOutlet weak var content: UIView!
    @IBOutlet weak var permAddPermissionsButton: UIButton!
    @IBOutlet weak var permSeeDocsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.addShadow()
        permAddPermissionsButton.blueButton()
        permSeeDocsButton.blueButton()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
