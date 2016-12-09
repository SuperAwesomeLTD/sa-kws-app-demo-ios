//
//  LeaderViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class LeaderRowViewModel : AnyObject, ViewModel {

    var rank: String
    var score: String
    var username: String
    
    init (_ rank: Int, _ score: Int, _ username: String?) {
        self.rank = "\(rank)"
        self.score = "\(score)"
        if let username = username {
            self.username = username
        } else {
            self.username = "leader_col_unknown_username".localized
        }
    }    
}
