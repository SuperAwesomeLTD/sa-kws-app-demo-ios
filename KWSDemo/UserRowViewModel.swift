//
//  UserItemViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils

class UserRowViewModel: AnyObject, ViewModel {
    var item: String
    var value: String
    var valueColor: UIColor?
    
    init (item: String, value: AnyObject?) {
        self.item = item
        if let value = value {
            self.value = "\(value)"
            self.valueColor = UIColor.black
            if value is Int && item != "ID" {
                if value as! Int > 0 {
                    self.valueColor = UIColorFromHex(0x396104)
                } else {
                    self.valueColor = UIColorFromHex(0x610404)
                }
            }
            if value is Bool {
                if value as! Bool == true {
                    self.value = "user_row_value_true".localized
                    self.valueColor = UIColor.black
                } else {
                    self.value = "user_row_value_false".localized
                    self.valueColor = UIColorFromHex(0x610404)
                }
            }
            if self.value == "" {
                self.value = "user_row_value_undefined".localized
                self.valueColor = UIColor.lightGray
            }
        } else {
            self.value = "user_row_value_undefined".localized
            self.valueColor = UIColor.lightGray
        }
    }
}
