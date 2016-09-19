//
//  GetAppDataViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class GetAppDataViewModel: AnyObject, ViewModel {
    
    var name: String
    var value: NSInteger = 0
    
    init (_ name: String, _ value: NSInteger) {
        self.name = name
        self.value = value
    }
    
    func heightForRow() -> CGFloat {
        return 44
    }
    
    func representationAsRow(tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GetAppDataRowId") as! GetAppDataRow
        cell.nameLabel.text = name
        cell.valueLabel.text = "\(value)"
        return cell
    }
    
}