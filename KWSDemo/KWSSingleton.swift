//
//  KWSSingleton.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 27/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class KWSSingleton: NSObject {
    // singleton
    static let sharedInstance = KWSSingleton()
    
    // user defaults
    private var userDefs = NSUserDefaults.standardUserDefaults()
    private var kwsModel: KWSModel?
    
    override init() {
        super.init()
        let userJson = userDefs.stringForKey("KWS_MODEL") as String?
        if let userJson = userJson {
            kwsModel = KWSModel(jsonString: userJson)
        }
    }
    
    func setModel(model: KWSModel?) {
        kwsModel = model
        
        if let kwsModel = kwsModel {
            let kwsModelJson = kwsModel.jsonPreetyStringRepresentation() as String?
            if let kwsModelJson = kwsModelJson {
                userDefs.setObject(kwsModelJson, forKey: "KWS_MODEL")
                userDefs.synchronize()
                print("Saved KWS Model for User \(kwsModel.username) into user defaults.")
            }
        } else {
            userDefs.removeObjectForKey("KWS_MODEL")
            userDefs.synchronize()
            print("Deleted current User from Defaults")
        }
    }
    
    func getModel() -> KWSModel? {
        return kwsModel
    }
    
    func appHasAuthenticatedUser () -> Bool {
        if kwsModel != nil {
            return true
        }
        return false
    }
}
