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
        self.layer.borderColor = UIColorFromHex(0x4A90E2).CGColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = (self.frame.size.height / 2.0)
        self.setTitleColor(UIColorFromHex(0x4A90E2), forState: .Normal)
        // let title = self.titleLabel?.text
        self.backgroundColor = UIColor.clearColor()
    }
}
