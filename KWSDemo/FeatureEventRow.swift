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
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var evtAdd20PointsButton: UIButton!
    @IBOutlet weak var evtSub10PointsButton: UIButton!
    @IBOutlet weak var evtGetScoreButton: UIButton!
    @IBOutlet weak var evtSeeLeaderboardButton: UIButton!
    @IBOutlet weak var evtSeeDocsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.addShadow()
        
        evtTitle.text = "feature_cell_evt_title".localized
        evtMessage.text = "feature_cell_evt_message".localized
        evtAdd20PointsButton.setTitle("feature_cell_evt_button_1".localized.uppercaseString, forState: UIControlState.Normal)
        evtSub10PointsButton.setTitle("feature_cell_evt_button_2".localized.uppercaseString, forState: UIControlState.Normal)
        evtGetScoreButton.setTitle("feature_cell_evt_button_3".localized.uppercaseString, forState: UIControlState.Normal)
        evtSeeLeaderboardButton.setTitle("feature_cell_evt_button_4".localized.uppercaseString, forState: UIControlState.Normal)
        evtSeeDocsButton.setTitle("feature_cell_evt_button_5".localized.uppercaseString, forState: UIControlState.Normal)
        
        evtAdd20PointsButton.blueButton()
        evtSub10PointsButton.blueButton()
        evtGetScoreButton.blueButton()
        evtSeeLeaderboardButton.blueButton()
        evtSeeDocsButton.blueButton()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
