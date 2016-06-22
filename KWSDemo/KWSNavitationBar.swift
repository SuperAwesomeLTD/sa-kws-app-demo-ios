//
//  KWSNavitationBar.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class KWSNavitationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // background
        self.barTintColor = UIColorFromHex(0xffffff)
        
        // image 1
        let logo_aa = UIImageView(image: UIImage(named: "logo_aa"))
        logo_aa.frame = CGRectMake(16, (self.frame.size.height - 36)/2, 163, 36)
        self.addSubview(logo_aa)
        
        // image 2
        let logo_sa = UIImageView(image: UIImage(named: "logo_sa"))
        logo_sa.frame = CGRectMake(self.frame.size.width - 16 - 95, (self.frame.size.height - 12) / 2, 95, 12)
        self.addSubview(logo_sa)
        
        // border
        let frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)
        let border = UIView(frame: frame)
        border.backgroundColor = UIColorFromHex(0xED1C24)
        self.addSubview(border)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var amendedSize = super.sizeThatFits(size)
        amendedSize.height += 40
        print(amendedSize.height)
        return amendedSize
    }
}
