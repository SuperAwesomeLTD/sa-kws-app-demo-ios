//
//  FeaturePermViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeaturePermViewModel: AnyObject/*, ViewModel*/ {

    fileprivate var loggedIn: Bool = false
    
//    func heightForRow() -> CGFloat {
//        return 248
//    }
//    
//    func representationAsRow(_ tableView: UITableView) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturePermRowId") as! FeaturePermRow
//        cell.permAddPermissionsButton.isEnabled = KWSSingleton.sharedInstance.isUserLogged()
//        cell.permAddPermissionsButton.addTarget(self, action: #selector(addPermissionAction), for: UIControlEvents.touchUpInside)
//        cell.permSeeDocsButton.addTarget(self, action: #selector(docsButtonAction), for: UIControlEvents.touchUpInside)
//        return cell
//    }
//    
//    @objc func addPermissionAction () {
//        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.PERM.rawValue), object: self)
//    }
//    
//    @objc func docsButtonAction () {
//        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.DOCS.rawValue), object: self)
//    }
}
