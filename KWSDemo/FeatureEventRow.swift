//
//  EventsTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureEventRow: UITableViewCell {
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var evtAdd20PointsButton: UIButton!
    @IBOutlet weak var evtSub10PointsButton: UIButton!
    @IBOutlet weak var evtGetScoreButton: UIButton!
    @IBOutlet weak var evtSeeLeaderboardButton: UIButton!
    @IBOutlet weak var evtSeeDocsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.addShadow()
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
