//
//  FeatureNotifViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureNotifViewModel: AnyObject, ViewModel {

    fileprivate var isLogged: Bool = false
    var isRegistered: Bool = false
    
    func heightForRow() -> CGFloat {
        return 248
    }
    
    func representationAsRow(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureNotifRowId") as! FeatureNotifRow
        cell.notifEnableOrDisableButton.isEnabled = KWSSingleton.sharedInstance.isUserLogged()
        if (KWSSingleton.sharedInstance.isUserMarkedAsRegistered()) {
            cell.notifEnableOrDisableButton.setTitle("feature_cell_notif_button_1_disable".localized.uppercased(), for: UIControlState())
        } else {
            cell.notifEnableOrDisableButton.setTitle("feature_cell_notif_button_1_enable".localized.uppercased(), for: UIControlState())
        }
        cell.notifEnableOrDisableButton.addTarget(self, action: #selector(notifButtonAction), for: .touchUpInside)
        cell.notifDocButton.addTarget(self, action: #selector(docsButtonAction), for: .touchUpInside)
        return cell
        
    }
    
    @objc func notifButtonAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.SUBSCRIBE.rawValue), object: self)
    }
    
    @objc func docsButtonAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.DOCS.rawValue), object: self)
    }
}
