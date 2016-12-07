//
//  LeaderboardViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class LeaderViewController: UIViewController/*, KWSPopupNavigationBarProtocol*/ {

    @IBOutlet weak var tableView: UITableView!
//    fileprivate var dataSource: LeaderDataSource!
//    fileprivate var spinnerM: SAActivityView!
//    fileprivate var popupM: SAPopup!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
//            bar.kwsdelegate = self
//        }
        
        
//        spinnerM = SAActivityView.sharedManager()
//        popupM = SAPopup.sharedManager()
//        dataSource = LeaderDataSource()
//        tableView.dataSource = dataSource
//        tableView.delegate = dataSource
//        dataSource.update(start: {
//                self.spinnerM.show()
//            }, success: { 
//                self.spinnerM.hide()
//                self.tableView.reloadData()
//            }, error: {
//                self.spinnerM.hide()
//                self.popupM.show(
//                    withTitle: "leader_popup_error_title".localized,
//                    andMessage: "leader_popup_error_message".localized,
//                    andOKTitle: "leader_popup_dismiss_button".localized,
//                    andNOKTitle: nil,
//                    andTextField: false,
//                    andKeyboardTyle: UIKeyboardType.default,
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
//        return "leader_vc_title".localized
//    }
//    
//    func kwsPopupNavDidPressOnClose() {
//        dismiss(animated: true) {
//            // flush
//        }
//    }

}
