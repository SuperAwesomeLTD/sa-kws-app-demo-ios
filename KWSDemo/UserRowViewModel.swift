//
//  UserItemViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class UserRowViewModel: AnyObject, ViewModel {
    var item: String
    var value: String
    var valueColor: UIColor?
    
    init (item: String, value: AnyObject?) {
        self.item = item
        if let value = value {
            self.value = "\(value)"
            self.valueColor = UIColor.blackColor()
            if value is Int && item != "ID" {
                if value as! Int > 0 {
                    self.valueColor = UIColorFromHex(0x396104)
                } else {
                    self.valueColor = UIColorFromHex(0x610404)
                }
            }
            if self.value == "" {
                self.value = "undefined"
                self.valueColor = UIColor.lightGrayColor()
            }
        } else {
            self.value = "undefined"
            self.valueColor = UIColor.lightGrayColor()
        }
    }
    
    func heightForRow() -> CGFloat {
        return 44
    }
    
    func representationAsRow(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserRowId") as! UserRow
        cell.titleLabel.text = self.item
        cell.valueLabel.text = self.value
        cell.valueLabel.textColor = self.valueColor
        return cell
    }
}
