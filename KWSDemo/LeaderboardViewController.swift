//
//  LeaderboardViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController,
    KWSPopupNavigationBarProtocol,
    UITableViewDelegate,
    UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private var data: [KWSLeader] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
        
        SAActivityView.sharedManager().showActivityView()
        KWS.sdk().getLeaderboard { (leaders: [KWSLeader]!) in
            SAActivityView.sharedManager().hideActivityView()
            
            if let leaders = leaders where leaders.count > 0 {
                self.data = leaders
                self.tableView.reloadData()
            } else {
                SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "An error occured and we could not get the Leaderboard. Please try again!", andOKTitle: "Got it!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: UIKeyboardType.Default, andPressed: nil)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Table stuff
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = data[indexPath.row] as KWSLeader
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderTableViewCellId", forIndexPath: indexPath) as! LeaderTableViewCell
        cell.RankLabel.text = "\(item.rank)"
        cell.PointsLabel.text = "\(item.score)"
        cell.UsernameLabel.text = item.user
        return cell
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
