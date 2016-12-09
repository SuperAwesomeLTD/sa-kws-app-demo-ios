//
//  UIView+KWSStyle.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils

class KWSShadowView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.white
        layer.masksToBounds = false
        layer.shadowColor = UIColorFromHex(0x898989).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.5)
        layer.shadowOpacity = 0.5
    }
    
}
