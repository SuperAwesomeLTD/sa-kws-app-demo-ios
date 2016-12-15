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
        col1title = "page_leader_header_rank".localized
        col2title = "page_leader_header_username".localized
        col3title = "page_leader_header_score".localized
    }
}
