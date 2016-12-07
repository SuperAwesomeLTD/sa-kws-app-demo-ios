//
//  LogOutViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 27/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

// vc
class UserViewController: UIViewController/*, KWSPopupNavigationBarProtocol, UITableViewDelegate*/ {
    
    // vars
//    var dataSource: UserDataSource!
//    var spinnerM: SAActivityView!
//    var popupM: SAPopup!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userDetailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
//            bar.kwsdelegate = self
//        }
//        
//        logoutButton.setTitle("user_logout".localized.uppercased(), for: UIControlState())
//        logoutButton.redButton()
//        spinnerM = SAActivityView.sharedManager()
//        popupM = SAPopup.sharedManager()
//        dataSource = UserDataSource()
//        userDetailsTableView.dataSource = dataSource
//        userDetailsTableView.delegate = dataSource
//        dataSource?.update(start: {
//                self.spinnerM.show()
//            }, success: {
//                self.spinnerM.hide()
//                self.userDetailsTableView.reloadData()
//            }, error: {
//                self.spinnerM.hide()
//                self.popupM.show(
//                    withTitle: "user_popup_error_title".localized,
//                    andMessage: "user_popup_error_message".localized,
//                    andOKTitle: "user_popup_dismiss_button".localized,
//                    andNOKTitle: nil,
//                    andTextField: false,
//                    andKeyboardTyle: .default,
//                    andPressed: nil)
//        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    // MARK: KWSPopupNavigationBarProtocol
//    
//    func kwsPopupNavGetTitle() -> String {
//        return "user_vc_title".localized
//    }
//    
//    func kwsPopupNavDidPressOnClose() {
//        dismiss(animated: true) {
//            // flush
//        }
//    }
    
    // MARK: Actions
    
    @IBAction func logoutAction(_ sender: AnyObject) {
//        dismiss(animated: true) { 
//            KWSSingleton.sharedInstance.logoutUser()
//        }
    }
}
