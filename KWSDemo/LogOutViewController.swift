//
//  LogOutViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 27/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

// protocol
protocol LogOutViewControllerProtocol {
    func logoutViewControllerDidManageToLogOutUser()
}

// vc
class LogOutViewController: UIViewController, KWSPopupNavigationBarProtocol {
    
    // outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tokenTextView: UITextView!
    @IBOutlet weak var logoutButton: UIButton!
    
    // delegate
    var delegate: LogOutViewControllerProtocol?
    
    // <Init & Load>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
        
        // setup logout button
        logoutButton.redButton()
        
        // get user
        let kwsUser = KWSSingleton.sharedInstance.getModel()
        if let kwsUser = kwsUser {
            usernameLabel.text = kwsUser.username
            tokenTextView.text = kwsUser.token
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .Black
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // <KWSPopupNavigationBarProtocol>
    
    func kwsPopupNavDidPressOnClose() {
        dismissViewControllerAnimated(true) {
            // flush
        }
    }
    
    // <Actions>
    
    @IBAction func logoutAction(sender: AnyObject) {
        KWSSingleton.sharedInstance.setModel(nil)
        dismissViewControllerAnimated(true) { 
            self.delegate?.logoutViewControllerDidManageToLogOutUser()
        }
    }
}
