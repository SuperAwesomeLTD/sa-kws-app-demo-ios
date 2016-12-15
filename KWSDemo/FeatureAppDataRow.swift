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
    @IBOutlet weak var appdSeeAppDataButton: KWSBlueButton!
    @IBOutlet weak var appdSeeDocsButton: KWSBlueButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        appdTitle.text = "page_features_row_appdata_title".localized
        appdMessage.text = "page_features_row_appdata_message".localized
        appdSeeAppDataButton.setTitle("page_features_row_appdata_button_see".localized.uppercased(), for: UIControlState())
        appdSeeDocsButton.setTitle("page_features_row_appdata_button_doc".localized.uppercased(), for: UIControlState())
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
