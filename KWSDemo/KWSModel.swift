//
//  KWSModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class KWSModel: SABaseObject {

    var status: Int?
    var userId: Int?
    var username: String?
    var token: String?
    var error: String?
    
    override init() {
        super.init()
    }
    
    required init!(jsonDictionary: [NSObject : AnyObject]!) {
        super.init()
        let json = jsonDictionary as NSDictionary
        status = json.safeObjectForKey("status") as? Int
        userId = json.safeObjectForKey("userId") as? Int
        token = json.safeObjectForKey("token") as? String
        username = json.safeObjectForKey("username") as? String
        error = json.safeObjectForKey("error") as? String
    }
    
    required convenience init!(jsonData: NSData!) {
        do {
            if let dictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.init(rawValue: 0)) as? NSDictionary {
                self.init(jsonDictionary: dictionary as [NSObject : AnyObject])
            }
            else {
                self.init()
            }
        } catch {
            self.init()
        }
    }
    
    required convenience init!(jsonString: String!) {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            self.init(jsonData: data)
        } else {
            self.init()
        }
    }
    
    override func dictionaryRepresentation() -> [NSObject : AnyObject]? {
        var dict: [NSObject: AnyObject] = [:]
        if let status = status {
            dict["status"] = status
        }
        if let userId = userId {
            dict["userId"] = userId
        }
        if let username = username {
            dict["username"] = username
        }
        if let token = token {
            dict["token"] = token
        }
        if let error = error {
            dict["error"] = error
        }
        return dict
    }
}
