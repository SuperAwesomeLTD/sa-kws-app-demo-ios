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
    
    func representationAsRow(_ tableView: UITableView) -> UITableViewCell {
        let local = KWSSingleton.sharedInstance.getUser()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureAuthRowId") as! FeatureAuthRow
        if let local = local, let username = local.username {
            cell.authActionButton.setTitle("feature_cell_auth_button_1_loggedin".localized.uppercased() + "\(username)".uppercased(), for: UIControlState())
        } else {
            cell.authActionButton.setTitle("feature_cell_auth_button_1_loggedout".localized.uppercased(), for: UIControlState())
        }
        
        cell.authActionButton.addTarget(self, action: #selector(authButtonAction), for: .touchUpInside)
        cell.authDocsButton.addTarget(self, action: #selector(docsButtonAction), for: .touchUpInside)
        return cell

    }
    
    @objc func authButtonAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.AUTH.rawValue), object: self)
    }
    
    @objc func docsButtonAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.DOCS.rawValue), object: self)
    }
    
}
