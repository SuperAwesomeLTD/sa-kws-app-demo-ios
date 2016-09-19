//
//  FeatureAuthViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureAuthViewModel: AnyObject, ViewModel {

    func heightForRow() -> CGFloat {
        return 298
    }
    
    func representationAsRow(tableView: UITableView) -> UITableViewCell {
        let local = KWSSingleton.sharedInstance.getUser()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeatureAuthRowId") as! FeatureAuthRow
        if let local = local, let username = local.username {
            cell.authActionButton.setTitle("feature_cell_auth_button_1_loggedin".localized.uppercaseString + "\(username)".uppercaseString, forState: .Normal)
        } else {
            cell.authActionButton.setTitle("feature_cell_auth_button_1_loggedout".localized.uppercaseString, forState: .Normal)
        }
        
        cell.authActionButton.addTarget(self, action: #selector(authButtonAction), forControlEvents: .TouchUpInside)
        cell.authDocsButton.addTarget(self, action: #selector(docsButtonAction), forControlEvents: .TouchUpInside)
        return cell

    }
    
    @objc func authButtonAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.AUTH.rawValue, object: self)
    }
    
    @objc func docsButtonAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.DOCS.rawValue, object: self)
    }
    
}
