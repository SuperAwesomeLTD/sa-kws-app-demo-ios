//
//  FeatureInviteViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureInviteViewModel: AnyObject, ViewModel {
    
    func heightForRow() -> CGFloat {
        return 248
    }
    
    func representationAsRow(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeatureInviteRowId") as! FeatureInviteRow
        let isLogged = KWSSingleton.sharedInstance.isUserLogged()
        cell.invInviteFriendButton.enabled = isLogged
        cell.invInviteFriendButton.addTarget(self, action: #selector(inviteFriendAction), forControlEvents: UIControlEvents.TouchUpInside)
        cell.invSeeDocsButton.addTarget(self, action: #selector(docsButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    @objc func inviteFriendAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.INVITE.rawValue, object: self)
    }
    
    @objc func docsButtonAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.DOCS.rawValue, object: self)
    }

}
