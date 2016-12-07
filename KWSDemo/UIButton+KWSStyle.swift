//
//  UIButton+KWSStyle.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils

extension UIButton {
    func blueButton () {
        self.layer.cornerRadius = (self.frame.size.height / 2.0)
        self.setTitleColor(UIColorFromHex(0x4A90E2), for: .normal)
        self.backgroundColor = UIColor.clear
        self.setTitleColor(UIColor.lightGray, for: .disabled)
        self.layer.borderColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1).cgColor
        self.layer.borderWidth = 2.0
        
//        self.layer.borderColor = UIColorFromHex(0x4A90E2).cgColor
    }
    
    func redButton () {
        self.backgroundColor = UIColorFromHex(0xED1C24)
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.white, for: UIControlState())
    }
}
