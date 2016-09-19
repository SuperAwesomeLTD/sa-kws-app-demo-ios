//
//  LeaderViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class LeaderRowViewModel : AnyObject, ViewModel {

    var rank: NSInteger = 0
    var score: NSInteger = 0
    var username: String
    
    init (_ rank: NSInteger, _ score: NSInteger, _ username: String?) {
        self.rank = rank
        self.score = score
        if let username = username {
            self.username = username
        } else {
            self.username = "leader_col_unknown_username".localized
        }
    }
    
    func heightForRow() -> CGFloat {
        return 44
    }
    
    func representationAsRow(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderRowId") as! LeaderRow
        cell.RankLabel.text = "\(rank)"
        cell.PointsLabel.text = "\(score)"
        cell.UsernameLabel.text = username
        return cell
    }
    
}
