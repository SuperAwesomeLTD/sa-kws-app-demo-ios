//
//  EventsTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

protocol EventsCellProtocol {
    func eventsCellProtocolDidClickOnAdd20Points ()
    func eventsCellprotocolDidClickOnSub10Points ()
    func eventsCellProtocolDidClickOnSeeLeaderboard ()
    func eventsCellprotocolDidClickOnDocs ()
}

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var evtAdd20PointsButton: UIButton!
    @IBOutlet weak var evtSub10PointsButton: UIButton!
    @IBOutlet weak var evtSeeLeaderboardButton: UIButton!
    @IBOutlet weak var evtSeeDocsButton: UIButton!
    
    var delegate: EventsCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.addShadow()
        evtAdd20PointsButton.blueButton()
        evtSub10PointsButton.blueButton()
        evtSeeLeaderboardButton.blueButton()
        evtSeeDocsButton.blueButton()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func evtAdd20PointsAction(sender: AnyObject) {
        delegate?.eventsCellProtocolDidClickOnAdd20Points()
    }
    
    @IBAction func evtSub10PointsAction(sender: AnyObject) {
        delegate?.eventsCellprotocolDidClickOnSub10Points()
    }
    
    @IBAction func evtSeeLeaderboardAction(sender: AnyObject) {
        delegate?.eventsCellProtocolDidClickOnSeeLeaderboard()
    }
    
    @IBAction func evtSeeDocsAction(sender: AnyObject) {
        delegate?.eventsCellprotocolDidClickOnDocs()
    }
}
