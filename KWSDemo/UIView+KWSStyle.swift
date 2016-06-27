//
//  UIView+KWSStyle.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow () {
        backgroundColor = UIColor.whiteColor()
        layer.masksToBounds = false
        layer.shadowColor = UIColorFromHex(0x898989).CGColor
        layer.shadowOffset = CGSizeMake(0, 2.5)
        layer.shadowOpacity = 0.5
      }
}