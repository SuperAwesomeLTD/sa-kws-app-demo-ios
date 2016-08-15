//
//  LogOutViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 27/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

// vc
class UserViewController: UIViewController, KWSPopupNavigationBarProtocol, UITableViewDelegate {
    
    // vars
    var dataSource: UserDataSource!
    var spinnerM: SAActivityView!
    var popupM: SAPopup!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userDetailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
        
        logoutButton.redButton()
        spinnerM = SAActivityView.sharedManager()
        popupM = SAPopup.sharedManager()
        dataSource = UserDataSource()
        userDetailsTableView.dataSource = dataSource
        userDetailsTableView.delegate = dataSource
        dataSource?.update(start: {
                self.spinnerM.showActivityView()
            }, success: {
                self.spinnerM.hideActivityView()
                self.userDetailsTableView.reloadData()
            }, error: {
                self.spinnerM.hideActivityView()
                self.popupM.showWithTitle(
                    "Hey!",
                    andMessage: "Could not load user data. Try again!",
                    andOKTitle: "Got it!",
                    andNOKTitle: nil,
                    andTextField: false,
                    andKeyboardTyle: .Default,
                    andPressed: nil)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .Black
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: KWSPopupNavigationBarProtocol
    
    func kwsPopupNavGetTitle() -> String {
        return "User details"
    }
    
    func kwsPopupNavDidPressOnClose() {
        dismissViewControllerAnimated(true) {
            // flush
        }
    }
    
    // MARK: Actions
    
    @IBAction func logoutAction(sender: AnyObject) {
        dismissViewControllerAnimated(true) { 
            KWSSingleton.sharedInstance.logoutUser()
        }
    }
}
