//
//  FeatureAppDataRow.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureAppDataRow: UITableViewCell {

    @IBOutlet weak var appdTitle: UILabel!
    @IBOutlet weak var appdMessage: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var appdSeeAppDataButton: UIButton!
    @IBOutlet weak var appdSeeDocsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        appdTitle.text = "feature_cell_appd_title".localized
        appdMessage.text = "feature_cell_appd_message".localized
        appdSeeAppDataButton.setTitle("feature_cell_appd_button_1".localized.uppercased(), for: UIControlState())
        appdSeeDocsButton.setTitle("feature_cell_appd_button_2".localized.uppercased(), for: UIControlState())
        
        content.addShadow()
        appdSeeAppDataButton.blueButton()
        appdSeeDocsButton.blueButton()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
