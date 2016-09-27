//
//  FeatureAppDataViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureAppDataViewModel: AnyObject, ViewModel {
    
    func heightForRow() -> CGFloat {
        return 248
    }
    
    func representationAsRow(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureAppDataRowId") as! FeatureAppDataRow
        let isLogged = KWSSingleton.sharedInstance.isUserLogged()
        cell.appdSeeAppDataButton.isEnabled = isLogged
        cell.appdSeeAppDataButton.addTarget(self, action: #selector(seeAppDataAction), for: UIControlEvents.touchUpInside)
        cell.appdSeeDocsButton.addTarget(self, action: #selector(docsButtonAction), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    @objc func seeAppDataAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.APPDATA.rawValue), object: self)
    }
    
    @objc func docsButtonAction () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.DOCS.rawValue), object: self)
    }
    
}
