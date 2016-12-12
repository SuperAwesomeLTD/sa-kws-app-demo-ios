//
//  KWSNavitationBar.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils

class KWSNavitationBar: UINavigationBar {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // background
        self.barTintColor = UIColorFromHex(0xffffff)
        
        // image 1
        let logo_aa = UIImageView(image: UIImage(named: "logo2_sa"))
        logo_aa.frame = CGRect(x: 16, y: (self.frame.size.height - 44)/2, width: 127, height: 44)
        self.addSubview(logo_aa)
        
        // image 2
        let logo_sa = UIImageView(image: UIImage(named: "logo_sa"))
        logo_sa.frame = CGRect(x: self.frame.size.width - 16 - 95, y: (self.frame.size.height - 12) / 2, width: 95, height: 12)
        self.addSubview(logo_sa)
        
        // border
        let frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        let border = UIView(frame: frame)
        border.backgroundColor = UIColorFromHex(0xED1C24)
        self.addSubview(border)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        
//    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var amendedSize = super.sizeThatFits(size)
        amendedSize.height += 40
        return amendedSize
    }
}
