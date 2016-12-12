//
//  UIButton+KWSStyle.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils
import QuartzCore

class KWSBlueButton : UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 15
        self.setTitleColor(UIColorFromHex(0x4A90E2), for: .normal)
        self.backgroundColor = UIColor.clear
        self.setTitleColor(UIColor.lightGray, for: .disabled)
        self.layer.borderColor = UIColorFromHex(0x4A90E2).cgColor
        self.layer.borderWidth = 2
    }
    
}

class KWSRedButton : UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColorFromHex(0xED1C24)
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
}

class KWSCountryButton: UIButton {
    
    public var border: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        
        // set size
        let W = UIScreen.main.bounds.width - 88
        let H = 30
        
        // add a border
        border = UIView()
        border?.frame = CGRect(x: 0, y: H-1, width: Int(W), height: 1)
        border?.backgroundColor = UIColor.lightGray
        self.addSubview(border!)
        
        // set button text color
        self.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
}
