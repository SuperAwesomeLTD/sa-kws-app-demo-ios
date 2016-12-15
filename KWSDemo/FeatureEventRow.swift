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
        
        evtTitle.text = "page_features_row_events_title".localized
        evtMessage.text = "page_features_row_events_content".localized
        evtAdd20PointsButton.setTitle("page_features_row_events_button_add20".localized.uppercased(), for: UIControlState())
        evtSub10PointsButton.setTitle("page_features_row_events_button_sub10".localized.uppercased(), for: UIControlState())
        evtGetScoreButton.setTitle("page_features_row_events_button_score".localized.uppercased(), for: UIControlState())
        evtSeeLeaderboardButton.setTitle("page_features_row_events_button_leaderboard".localized.uppercased(), for: UIControlState())
        evtSeeDocsButton.setTitle("page_features_row_events_button_doc".localized.uppercased(), for: UIControlState())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
