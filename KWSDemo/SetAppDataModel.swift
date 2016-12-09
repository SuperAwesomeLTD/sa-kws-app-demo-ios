//
//  SetAppDataModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class SetAppDataModel: NSObject {

    fileprivate let INVALID_VALID = -Int.max
    fileprivate var name: String! = nil
    fileprivate var value: Int = 0
    
    init (name: String?, value: String?) {
        
        // get a name var
        if let name = name , name != "" {
            self.name = name
        } else {
            self.name = nil
        }
        
        // get a value var, if possible
        if let value = value , value != "", let ivalue = Int(value) {
            self.value = ivalue
        }
        else {
            self.value = INVALID_VALID
        }
        
        // call to super
        super.init()
    }
    
    static func createEmpty () -> SetAppDataModel {
        return SetAppDataModel (name: nil, value: nil)
    }
    
    func isValid () -> Bool {
        return name != nil && value != INVALID_VALID
    }
    
    func getName () -> String! {
        return name
    }
    
    func getValue () -> Int {
        return value
    }
}
