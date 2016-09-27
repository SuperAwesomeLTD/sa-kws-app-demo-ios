//
//  FeatureEventViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureEventViewModel: AnyObject, ViewModel {

    func heightForRow() -> CGFloat {
        return 368
    }
    
    func representationAsRow(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureEventRowId") as! FeatureEventRow
        let isLogged = KWSSingleton.sharedInstance.isUserLogged()
        cell.evtAdd20PointsButton.isEnabled = isLogged
        cell.evtSub10PointsButton.isEnabled = isLogged
        cell.evtSeeLeaderboardButton.isEnabled = isLogged
        cell.evtGetScoreButton.isEnabled = isLogged
        cell.evtAdd20PointsButton.addTarget(self, action: #selector(add20PointsAction), for: UIControlEvents.touchUpInside)
        cell.evtSub10PointsButton.addTarget(self, action: #selector(sub10PointsAction), for: UIControlEvents.touchUpInside)
        cell.evtGetScoreButton.addTarget(self, action: #selector(getScoreAction), for: UIControlEvents.touchUpInside)
        cell.evtSeeLeaderboardButton.addTarget(self, action: #selector(seeLeaderAction), for: UIControlEvents.touchUpInside)
        cell.evtSeeDocsButton.addTarget(self, action: #selector(docsButtonAction), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    @objc func add20PointsAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.ADD_20.rawValue), object: self)
    }
    
    @objc func sub10PointsAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.SUB_10.rawValue), object: self)
    }
    
    @objc func getScoreAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.SCORE.rawValue), object: self)
    }
    
    @objc func seeLeaderAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.LEADER.rawValue), object: self)
    }
    
    @objc func docsButtonAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.DOCS.rawValue), object: self)
    }
}
