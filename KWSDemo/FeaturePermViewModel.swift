//
//  FeaturePermViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeaturePermViewModel: AnyObject, ViewModel {

    private var loggedIn: Bool = false
    
    func heightForRow() -> CGFloat {
        return 248
    }
    
    func representationAsRow(tableView: UITableView) -> UITableViewCell {
        loggedIn = KWSSingleton.sharedInstance.getModel() != nil
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeaturePermRowId") as! FeaturePermRow
        cell.permAddPermissionsButton.enabled = loggedIn
        cell.permAddPermissionsButton.addTarget(self, action: #selector(addPermissionAction), forControlEvents: UIControlEvents.TouchUpInside)
        cell.permSeeDocsButton.addTarget(self, action: #selector(docsButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    @objc func addPermissionAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.PERM.rawValue, object: self)
    }
    
    @objc func docsButtonAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.DOCS.rawValue, object: self)
    }
}
