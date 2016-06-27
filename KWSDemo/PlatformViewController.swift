//
//  ViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class PlatformViewController: UIViewController {

    // outlets
    @IBOutlet weak var knowMoreButton: UIButton!
    
    // contants
    private let urlStr = "http://www.superawesome.tv/en/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        knowMoreButton.blueButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func knowMoreAction(sender: AnyObject) {
        let url = NSURL(string: urlStr)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    // <Custom>
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
}

