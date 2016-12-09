//
//  EventsTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureEventRow: UITableViewCell {
    
    @IBOutlet weak var evtTitle: UILabel!
    @IBOutlet weak var evtMessage: UILabel!
    @IBOutlet weak var evtAdd20PointsButton: KWSBlueButton!
    @IBOutlet weak var evtSub10PointsButton: KWSBlueButton!
    @IBOutlet weak var evtGetScoreButton: KWSBlueButton!
    @IBOutlet weak var evtSeeLeaderboardButton: KWSBlueButton!
    @IBOutlet weak var evtSeeDocsButton: KWSBlueButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        evtTitle.text = "feature_cell_evt_title".localized
        evtMessage.text = "feature_cell_evt_message".localized
        evtAdd20PointsButton.setTitle("feature_cell_evt_button_1".localized.uppercased(), for: UIControlState())
        evtSub10PointsButton.setTitle("feature_cell_evt_button_2".localized.uppercased(), for: UIControlState())
        evtGetScoreButton.setTitle("feature_cell_evt_button_3".localized.uppercased(), for: UIControlState())
        evtSeeLeaderboardButton.setTitle("feature_cell_evt_button_4".localized.uppercased(), for: UIControlState())
        evtSeeDocsButton.setTitle("feature_cell_evt_button_5".localized.uppercased(), for: UIControlState())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
