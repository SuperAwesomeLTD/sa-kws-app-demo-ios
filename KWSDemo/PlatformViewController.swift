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
    @IBOutlet weak var platformTitle: UILabel!
    @IBOutlet weak var platformContent: UILabel!
    @IBOutlet weak var platformFeature1: UILabel!
    @IBOutlet weak var platformFeature2: UILabel!
    @IBOutlet weak var platformFeature3: UILabel!
    @IBOutlet weak var platformFeature4: UILabel!
    @IBOutlet weak var knowMoreButton: KWSBlueButton!
    
    // contants
    fileprivate let urlStr = "http://www.superawesome.tv/en/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate ()
        
        platformTitle.text = "platform_title".localized
        platformContent.text = "platform_content".localized
        platformFeature1.text = "platform_feature_1".localized
        platformFeature2.text = "platform_feature_2".localized
        platformFeature3.text = "platform_feature_3".localized
        platformFeature4.text = "platform_feature_4".localized
        knowMoreButton.setTitle("platform_main_button".localized.uppercased(), for: UIControlState())
    }

    override func didReceiveMemoryWarning () {
        super.didReceiveMemoryWarning ()
    }

    @IBAction func knowMoreAction (_ sender: AnyObject) {
        let url = URL(string: urlStr)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    // <Custom>
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

