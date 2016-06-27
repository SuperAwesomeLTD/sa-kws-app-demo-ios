//
//  FeaturesDataSource.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeaturesDataSource: NSObject, UITableViewDataSource {

    var authDelegate: AuthCellProtocol?
    var notifDelegate: NotifCellProtocol?
    
    // <UITableViewDataSource>
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("AuthTableViewCellId", forIndexPath: indexPath) as! AuthTableViewCell
            cell.selectionStyle = .None
            cell.delegate = authDelegate
            
            // get data for User
            if let kwsModel = KWSSingleton.sharedInstance.getModel(), let username = kwsModel.username {
                cell.authActionButton.setTitle("Loged in as \(username)".uppercaseString, forState: .Normal)
            } else {
                cell.authActionButton.setTitle("Authenticate user".uppercaseString, forState: .Normal)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NotifTableViewCellId", forIndexPath: indexPath) as! NotifTableViewCell
            cell.selectionStyle = .None
            cell.delegate = notifDelegate
            return cell
        }
    }
}
