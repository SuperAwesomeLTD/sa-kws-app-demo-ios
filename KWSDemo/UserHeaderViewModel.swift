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
}
