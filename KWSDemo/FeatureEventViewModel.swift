//
//  FeatureEventViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureEventViewModel: AnyObject, ViewModel {

    private var loggedIn: Bool = false
    
    func heightForRow() -> CGFloat {
        return 328
    }
    
    func representationAsRow(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeatureEventRowId") as! FeatureEventRow
        cell.evtAdd20PointsButton.enabled = KWSSingleton.sharedInstance.isUserLogged()
        cell.evtSub10PointsButton.enabled = KWSSingleton.sharedInstance.isUserLogged()
        cell.evtSeeLeaderboardButton.enabled = KWSSingleton.sharedInstance.isUserLogged()
        cell.evtAdd20PointsButton.addTarget(self, action: #selector(add20PointsAction), forControlEvents: UIControlEvents.TouchUpInside)
        cell.evtSub10PointsButton.addTarget(self, action: #selector(sub10PointsAction), forControlEvents: UIControlEvents.TouchUpInside)
        cell.evtSeeLeaderboardButton.addTarget(self, action: #selector(seeLeaderAction), forControlEvents: UIControlEvents.TouchUpInside)
        cell.evtSeeDocsButton.addTarget(self, action: #selector(docsButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    @objc func add20PointsAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.ADD_20.rawValue, object: self)
    }
    
    @objc func sub10PointsAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.SUB_10.rawValue, object: self)
    }
    
    @objc func seeLeaderAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.LEADER.rawValue, object: self)
    }
    
    @objc func docsButtonAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.DOCS.rawValue, object: self)
    }
}
