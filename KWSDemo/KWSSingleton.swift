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
    fileprivate var userDefs = UserDefaults.standard
    fileprivate var kwsModel: KWSModel?
    fileprivate dynamic var isRegistered: Bool = false
    fileprivate dynamic var isLogged: Bool = false
    
    override init() {
        super.init()
        start()
    }
    
    func start () {
        let userJson = userDefs.string(forKey: "KWS_MODEL") as String?
        if let userJson = userJson {
            kwsModel = KWSModel(jsonString: userJson)
            self.isLogged = true
            self.didChangeValue(forKey: "isLogged")
        } else {
            self.isLogged = false
            self.didChangeValue(forKey: "isLogged")
        }
    }
    
    func loginUser(_ model: KWSModel) {
        kwsModel = model
        if let kwsModel = kwsModel,
            let kwsModelJson = kwsModel.jsonPreetyStringRepresentation() as String? {
            userDefs.set(kwsModelJson, forKey: "KWS_MODEL")
            userDefs.synchronize()
            self.isLogged = true
            self.didChangeValue(forKey: "isLogged")
        }
    }
    
    func logoutUser () {
        kwsModel = nil
        userDefs.removeObject(forKey: "KWS_MODEL")
        userDefs.synchronize()
        self.isLogged = false
        self.didChangeValue(forKey: "isLogged")
    }
    
    func isUserLogged () -> Bool {
        return self.isLogged
    }
    
    func getUser () -> KWSModel? {
        return self.kwsModel
    }
    
    func markUserAsRegistered () {
        self.isRegistered = true
        self.didChangeValue(forKey: "isRegistered")
    }
    
    func markUserAsUnregistered () {
        self.isRegistered = false
        self.didChangeValue(forKey: "isRegistered")
    }
    
    func isUserMarkedAsRegistered () -> Bool {
        return self.isRegistered
    }
}
