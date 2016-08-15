//
//  FeatureNotifViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureNotifViewModel: AnyObject, ViewModel {

    private var isLogged: Bool = false
    var isRegistered: Bool = false
    
    func heightForRow() -> CGFloat {
        return 248
    }
    
    func representationAsRow(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeatureNotifRowId") as! FeatureNotifRow
        cell.notifEnableOrDisableButton.enabled = KWSSingleton.sharedInstance.isUserLogged()
        if (KWSSingleton.sharedInstance.isUserMarkedAsRegistered()) {
            cell.notifEnableOrDisableButton.setTitle("DISABLE PUSH NOTIFICATIONS", forState: .Normal)
        } else {
            cell.notifEnableOrDisableButton.setTitle("ENABLE PUSH NOTIFICATIONS", forState: .Normal)
        }
        cell.notifEnableOrDisableButton.addTarget(self, action: #selector(notifButtonAction), forControlEvents: .TouchUpInside)
        cell.notifDocButton.addTarget(self, action: #selector(docsButtonAction), forControlEvents: .TouchUpInside)
        return cell
        
    }
    
    @objc func notifButtonAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.SUBSCRIBE.rawValue, object: self)
    }
    
    @objc func docsButtonAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.DOCS.rawValue, object: self)
    }
}
