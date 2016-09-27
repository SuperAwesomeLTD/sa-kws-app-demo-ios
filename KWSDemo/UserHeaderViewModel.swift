//
//  UserHeaderViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class UserHeaderViewModel: AnyObject, ViewModel {

    var title: String
    
    init (title: String) {
        self.title = title
    }
    
    func heightForRow() -> CGFloat {
        return 44
    }
    
    func representationAsRow(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserHeaderId") as! UserHeader
        cell.headerTitle.text = self.title
        return cell
    }
}
