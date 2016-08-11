//
//  LeaderHeaderViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class LeaderHeaderViewModel: AnyObject, ViewModel {

    var col1title: String
    var col2title: String
    var col3title: String
    
    init() {
        col1title = "#"
        col2title = "Username"
        col3title = "Score"
    }
    
    func heightForRow() -> CGFloat {
        return 44
    }
    
    func representationAsRow(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderHeaderId") as! LeaderHeader
        cell.rankLabel.text = col1title
        cell.usernameLabel.text = col2title
        cell.pointsLabel.text = col3title
        return cell
    }
    
    
}
