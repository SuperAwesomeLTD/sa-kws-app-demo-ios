//
//  LeaderboardDataSource.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class LeaderDataSource: NSObject, DataSource, UITableViewDataSource, UITableViewDelegate {

    private var header: ViewModel = LeaderHeaderViewModel()
    private var rows: [ViewModel] = []
    
    // MARK: DataSourceProtocol
    
    func update(start start: () -> Void, success: () -> Void, error: () -> Void) {
        start()
        
        KWS.sdk().getLeaderboard { (leaders: [KWSLeader]!) in
            if let leaders = leaders where leaders.count > 0 {
                for leader in leaders {
                    self.rows.append(LeaderRowViewModel(rank: leader.rank, score: leader.score, username: leader.user))
                }
                success()
            } else {
                error()
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return header.heightForRow()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header.representationAsRow(tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rows[indexPath.row].heightForRow()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return rows[indexPath.row].representationAsRow(tableView)
    }
    
}
