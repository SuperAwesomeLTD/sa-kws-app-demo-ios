//
//  SAActivityView.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 27/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class KWSActivityView: NSObject {
    
    // subviews & references
    private var win:UIWindow?
    private var blackView: UIView!
    private var activityView: UIActivityIndicatorView!
    
    // singleton
    static let sharedInstance = KWSActivityView()
    
    override init() {
        super.init()
        self.win = UIApplication.sharedApplication().delegate!.window!!
    }
    
    func showActivityView () {
        let frame = UIScreen.mainScreen().bounds
        blackView = UIView(frame: frame)
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.25)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView.center = blackView.center
        blackView.addSubview(activityView)
        
        win?.addSubview(blackView)
        activityView?.startAnimating()
    }
    
    func hideActivityView () {
        activityView.stopAnimating()
        activityView.removeFromSuperview()
        blackView.removeFromSuperview()
    }
}