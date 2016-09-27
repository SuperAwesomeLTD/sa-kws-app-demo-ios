//
//  UITextField+KWSStyle.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

extension UITextField {
    func kwsStyle () {
        
        let W = self.frame.size.width
        let H = self.frame.size.height
        
        let border = UIView()
        border.frame = CGRect(x: 0, y: H-1, width: W, height: 1)
        border.backgroundColor = UIColor.lightGray
        self.addSubview(border)
        
    }
}
