//
//  UIButton+KWSStyle.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

extension UIButton {
    func blueButton () {
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = (self.frame.size.height / 2.0)
        self.setTitleColor(UIColorFromHex(0x4A90E2), for: .normal)
        self.backgroundColor = UIColor.clear
        self.setTitleColor(UIColor.lightGray, for: .disabled)
        self.layer.borderColor = UIColorFromHex(0x4A90E2).cgColor
    }
    
    func redButton () {
        self.backgroundColor = UIColorFromHex(0xED1C24)
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.white, for: UIControlState())
    }
}
