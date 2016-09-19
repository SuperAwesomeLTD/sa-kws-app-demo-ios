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
    
    func representationAsRow(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeatureAppDataRowId") as! FeatureAppDataRow
        let isLogged = KWSSingleton.sharedInstance.isUserLogged()
        cell.appdSeeAppDataButton.enabled = isLogged
        cell.appdSeeAppDataButton.addTarget(self, action: #selector(seeAppDataAction), forControlEvents: UIControlEvents.TouchUpInside)
        cell.appdSeeDocsButton.addTarget(self, action: #selector(docsButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    @objc func seeAppDataAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.APPDATA.rawValue, object: self)
    }
    
    @objc func docsButtonAction () {
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.DOCS.rawValue, object: self)
    }
    
}