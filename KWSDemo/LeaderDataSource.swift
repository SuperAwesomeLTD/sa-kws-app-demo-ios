//
//  LeaderboardDataSource.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class LeaderDataSource: NSObject, DataSource, UITableViewDataSource, UITableViewDelegate {
    

    fileprivate var header: ViewModel = LeaderHeaderViewModel()
    fileprivate var rows: [ViewModel] = []
    
    // MARK: DataSourceProtocol
    
    internal func update(start: @escaping () -> Void, success: @escaping () -> Void, error: @escaping () -> Void) {
        start()
        
        KWS.sdk().getLeaderboard { (leaders: [KWSLeader]?) in
            if let leaders = leaders {
                self.rows = leaders.map({ (leader) -> ViewModel in
                    return LeaderRowViewModel(leader.rank, leader.score, leader.user)
                })
                
                success()
            } else {
                error()
            }
        }
    }

    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return header.heightForRow()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header.representationAsRow(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rows[(indexPath as NSIndexPath).row].heightForRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return rows[(indexPath as NSIndexPath).row].representationAsRow(tableView)
    }
    
}
