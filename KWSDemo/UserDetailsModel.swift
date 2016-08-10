//
//  UserDetailsModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 10/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

enum UserDetailModelType {
    case HEADER
    case ITEM
}

class UserDetailsModel: NSObject {
    
    var headerText: String?
    var itemTitle: String?
    var itemValue: AnyObject?
    var type: UserDetailModelType = .ITEM
    
    static func Header(header: String) -> UserDetailsModel {
        let model: UserDetailsModel = UserDetailsModel ()
        model.headerText = header
        model.type = .HEADER
        return model
    }
    
    static func Item(title: String, _ value: AnyObject!) -> UserDetailsModel {
        let model: UserDetailsModel = UserDetailsModel ()
        model.itemTitle = title
        model.itemValue = value
        model.type = .ITEM
        return model
    }

}
