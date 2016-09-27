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
    
    required init!(jsonDictionary: [AnyHashable: Any]!) {
        super.init()
        let json = jsonDictionary as NSDictionary
        status = json.safeObject(forKey: "status") as? Int
        userId = json.safeObject(forKey: "userId") as? Int
        token = json.safeObject(forKey: "token") as? String
        username = json.safeObject(forKey: "username") as? String
        error = json.safeObject(forKey: "error") as? String
    }
    
    required convenience init!(jsonData: Data!) {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? NSDictionary {
                self.init(jsonDictionary: dictionary as! [AnyHashable: Any])
            }
            else {
                self.init()
            }
        } catch {
            self.init()
        }
    }
    
    required convenience init!(jsonString: String!) {
        if let data = jsonString.data(using: String.Encoding.utf8) {
            self.init(jsonData: data)
        } else {
            self.init()
        }
    }
    
    override func dictionaryRepresentation() -> [AnyHashable: Any]? {
        var dict: [AnyHashable: Any] = [:]
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
