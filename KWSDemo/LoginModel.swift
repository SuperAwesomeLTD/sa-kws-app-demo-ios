//
//  SignInModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 09/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class LoginModel: NSObject {

    private var username: String?
    private var password: String?
    
    init(username: String?, password: String?) {
        super.init()
        self.username = username
        self.password = password
    }
    
    static func createEmpty () -> LoginModel {
        return LoginModel (username: nil, password: nil)
    }
    
    func isValid () -> Bool {
        if let _ = username, let _ = password {
            return true
        }
        return false
    }
    
    func getUsername () -> String {
        if let username = username {
            return username
        }
        return ""
    }
    
    func getPassword () -> String {
        if let password = password {
            return password
        }
        return ""
    }
    
}
