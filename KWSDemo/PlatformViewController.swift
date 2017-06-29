//
//  ViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class PlatformViewController: KWSBaseController {

    // outlets
    @IBOutlet weak var platformTitle: UILabel!
    @IBOutlet weak var platformContent: UILabel!
    @IBOutlet weak var platformFeature1: UILabel!
    @IBOutlet weak var platformFeature2: UILabel!
    @IBOutlet weak var platformFeature3: UILabel!
    @IBOutlet weak var platformFeature4: UILabel!
    @IBOutlet weak var knowMoreButton: KWSBlueButton!
    @IBOutlet weak var platformIcon1: UIImageView!
    @IBOutlet weak var platformIcon2: UIImageView!
    @IBOutlet weak var platformIcon3: UIImageView!
    @IBOutlet weak var platformIcon4: UIImageView!
    
    // contants
    fileprivate let urlStr = "http://www.superawesome.tv/en/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        platformTitle.text = "page_platform_text_welcome".localized
        platformContent.text = "page_platform_text_content".localized
        platformFeature1.text = "page_platform_text_feature_1".localized
        platformFeature2.text = "page_platform_text_feature_2".localized
        platformFeature3.text = "page_platform_text_feature_3".localized
        platformFeature4.text = "page_platform_text_feature_4".localized
        knowMoreButton.setTitle("page_platform_button_more".localized.uppercased(), for: UIControlState())
        
        platformIcon1.image = platformIcon1.image?.withRenderingMode(.alwaysTemplate)
        platformIcon1.tintColor = UIColor(colorLiteralRed: 70.0/255.0, green: 35.0/255.0, blue: 122.0/255.0, alpha: 1)
        
        platformIcon2.image = platformIcon2.image?.withRenderingMode(.alwaysTemplate)
        platformIcon2.tintColor = UIColor(colorLiteralRed: 70.0/255.0, green: 35.0/255.0, blue: 122.0/255.0, alpha: 1)
        
        platformIcon3.image = platformIcon3.image?.withRenderingMode(.alwaysTemplate)
        platformIcon3.tintColor = UIColor(colorLiteralRed: 70.0/255.0, green: 35.0/255.0, blue: 122.0/255.0, alpha: 1)
        
        platformIcon4.image = platformIcon4.image?.withRenderingMode(.alwaysTemplate)
        platformIcon4.tintColor = UIColor(colorLiteralRed: 70.0/255.0, green: 35.0/255.0, blue: 122.0/255.0, alpha: 1)
        
        // on tap
        knowMoreButton.rx.tap
            .subscribe (onNext: { (Void) in
    
                let url = URL(string: self.urlStr)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
                
            })
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "page_platform_title".localized
    }

    override func didReceiveMemoryWarning () {
        super.didReceiveMemoryWarning ()
    }
}

