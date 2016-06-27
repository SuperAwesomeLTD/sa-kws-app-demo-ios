//
//  KWSSimpleAlert.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 27/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class KWSSimpleAlert: NSObject {
    // singleton
    static let sharedInstance = KWSSimpleAlert()
    
    override init() {
        super.init()
    }
    
    func show(vc: UIViewController, title: String, message:String, button: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: button, style: .Default) { (action) in }
        alert.addAction(OKAction)
        vc.presentViewController(alert, animated: true) {}
    }
}
