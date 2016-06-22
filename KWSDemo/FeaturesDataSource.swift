//
//  FeaturesDataSource.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeaturesDataSource: NSObject, UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("AuthTableViewCellId", forIndexPath: indexPath) as! AuthTableViewCell
            cell.selectionStyle = .None
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NotifTableViewCellId", forIndexPath: indexPath) as! NotifTableViewCell
            cell.selectionStyle = .None
            return cell
        }
    }
}
