//
//  ViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

protocol ViewModel {
    func heightForRow () -> CGFloat
    func representationAsRow(_ tableView: UITableView) -> UITableViewCell
}
