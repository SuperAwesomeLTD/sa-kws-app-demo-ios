//
//  DocumentationViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class DocumentationViewController: UIViewController {

    // constants
    let urlStr: String = "https://developers.superawesome.tv/"
    
    // outlets
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        webView.loadRequest(URLRequest(url: URL(string: urlStr)!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // <Custom>
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}
