//
//  NSString+KWSStyle.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 19/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
