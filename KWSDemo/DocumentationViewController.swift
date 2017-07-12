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
    let urlStr: String = "http://doc.superawesome.tv/sa-kws-ios-sdk/latest/"
    
    // outlets
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: urlStr)!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "page_documentation_title".localized
    }
}
