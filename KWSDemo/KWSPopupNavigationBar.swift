//
//  KWSPopupNavigationBar.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

protocol KWSPopupNavigationBarProtocol {
    func kwsPopupNavGetTitle () -> String
    func kwsPopupNavDidPressOnClose()
}

class KWSPopupNavigationBar: UINavigationBar {

    var close: UIButton!
    var kwsdelegate: KWSPopupNavigationBarProtocol?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // customize background
        backgroundColor = UIColorFromHex(0xED1C24)
        barTintColor = UIColorFromHex(0xED1C24)
        translucent = false
        
        // self frame
        let W = self.frame.size.width
        let H = self.frame.size.height
        let font = UIFont(name: "SFUIText-Semibold", size: 12)
        
        // add close button
        let btnframe = CGRectMake(W - 80, 0, 80, H)
        close = UIButton(frame: btnframe)
        close.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        close.setTitle("kws_popup_nav_bar_close".localized.uppercaseString, forState: .Normal)
        close.titleLabel!.font = font
        close.addTarget(self, action: #selector(KWSPopupNavigationBar.doSometing), forControlEvents: .TouchUpInside)
        addSubview(close)
        
        // add title
        let titleframe = CGRectMake(8, 0, W - 72, H)
        let title = UILabel(frame: titleframe)
        title.text = kwsdelegate?.kwsPopupNavGetTitle() // "Sign Up to KWS"
        title.textColor = UIColor.whiteColor()
        title.font = font
        addSubview(title)
    }
    
    func doSometing () {
        kwsdelegate?.kwsPopupNavDidPressOnClose()
    }
}
