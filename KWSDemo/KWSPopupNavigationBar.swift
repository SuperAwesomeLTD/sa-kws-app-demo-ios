//
//  KWSPopupNavigationBar.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils

protocol KWSPopupNavigationBarProtocol {
    func kwsPopupNavDidPressOnClose()
}

class KWSPopupNavigationBar: UINavigationBar {

    @IBInspectable var navigationBarTitle: String = ""
    
    var close: UIButton!
    var kwsdelegate: KWSPopupNavigationBarProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // set bar style
        barStyle = .black
        
        // customize background
        backgroundColor = UIColorFromHex(0xED1C24)
        barTintColor = UIColorFromHex(0xED1C24)
        isTranslucent = false
        
        // self frame
        let W = self.frame.size.width
        let H = self.frame.size.height
        let font = UIFont(name: "SFUIText-Semibold", size: 12)
        
        // add close button
        let btnframe = CGRect(x: W - 80, y: 0, width: 80, height: H)
        close = UIButton(frame: btnframe)
        close.setTitleColor(UIColor.white, for: .normal)
        close.setTitle("kws_popup_nav_bar_close".localized.uppercased(), for: .normal)
        close.titleLabel!.font = font
        close.addTarget(self, action: #selector(KWSPopupNavigationBar.doSometing), for: .touchUpInside)
        addSubview(close)
        
        // add title
        let titleframe = CGRect(x: 8, y: 0, width: W - 72, height: H)
        let title = UILabel(frame: titleframe)
        title.text = navigationBarTitle.localized
        title.textColor = UIColor.white
        title.font = font
        addSubview(title)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        
//    }
    
    func doSometing () {
        kwsdelegate?.kwsPopupNavDidPressOnClose()
    }
    
}
