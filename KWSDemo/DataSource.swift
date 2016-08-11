//
//  DataSourceProtocol.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

protocol DataSource {
    func update(start start: ()->Void, success: ()->Void, error: ()->Void) -> Void
}
