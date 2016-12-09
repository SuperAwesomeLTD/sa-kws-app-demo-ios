//
//  KWSTabBarController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 07/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils

class KWSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = UIColorFromHex(0xf9f9f9)
        self.tabBar.tintColor = UIColorFromHex(0xED1C24)
        self.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColorFromHex(0xED1C24)], for: .selected)
        self.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColorFromHex(0x929292)], for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
