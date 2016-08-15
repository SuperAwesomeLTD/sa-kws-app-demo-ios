//
//  LeaderboardViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class LeaderViewController: UIViewController, KWSPopupNavigationBarProtocol {

    @IBOutlet weak var tableView: UITableView!
    private var dataSource: LeaderDataSource!
    private var spinnerM: SAActivityView!
    private var popupM: SAPopup!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
        
        
        spinnerM = SAActivityView.sharedManager()
        popupM = SAPopup.sharedManager()
        dataSource = LeaderDataSource()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        dataSource.update(start: {
                self.spinnerM.showActivityView()
            }, success: { 
                self.spinnerM.hideActivityView()
                self.tableView.reloadData()
            }, error: {
                self.spinnerM.hideActivityView()
                self.popupM.showWithTitle(
                    "Hey!",
                    andMessage: "An error occured and we could not get the Leaderboard. Please try again!",
                    andOKTitle: "Got it!",
                    andNOKTitle: nil,
                    andTextField: false,
                    andKeyboardTyle: UIKeyboardType.Default,
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
        return "Leaderboard"
    }
    
    func kwsPopupNavDidPressOnClose() {
        dismissViewControllerAnimated(true) {
            // flush
        }
    }

}