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
    private dynamic var isRegistered: Bool = false
    private dynamic var isLogged: Bool = false
    
    override init() {
        super.init()
        start()
    }
    
    func start () {
        let userJson = userDefs.stringForKey("KWS_MODEL") as String?
        if let userJson = userJson {
            kwsModel = KWSModel(jsonString: userJson)
            self.isLogged = true
            self.didChangeValueForKey("isLogged")
        } else {
            self.isLogged = false
            self.didChangeValueForKey("isLogged")
        }
    }
    
    func loginUser(model: KWSModel) {
        kwsModel = model
        if let kwsModel = kwsModel,
            let kwsModelJson = kwsModel.jsonPreetyStringRepresentation() as String? {
            userDefs.setObject(kwsModelJson, forKey: "KWS_MODEL")
            userDefs.synchronize()
            self.isLogged = true
            self.didChangeValueForKey("isLogged")
        }
    }
    
    func logoutUser () {
        kwsModel = nil
        userDefs.removeObjectForKey("KWS_MODEL")
        userDefs.synchronize()
        self.isLogged = false
        self.didChangeValueForKey("isLogged")
    }
    
    func isUserLogged () -> Bool {
        return self.isLogged
    }
    
    func getUser () -> KWSModel? {
        return self.kwsModel
    }
    
    func markUserAsRegistered () {
        self.isRegistered = true
        self.didChangeValueForKey("isRegistered")
    }
    
    func markUserAsUnregistered () {
        self.isRegistered = false
        self.didChangeValueForKey("isRegistered")
    }
    
    func isUserMarkedAsRegistered () -> Bool {
        return self.isRegistered
    }
}
