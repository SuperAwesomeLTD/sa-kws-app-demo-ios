//
//  GetAppDataViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class GetAppDataViewModel: AnyObject {
    
    var name: String
    var value: String
    
    init (_ name: String, _ value: NSInteger) {
        self.name = name
        self.value = "\(value)"
    }
}
