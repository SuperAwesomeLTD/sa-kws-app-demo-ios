//
//  DataSourceProtocol.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

protocol DataSource {
    func update(start: @escaping ()->Void, success: @escaping ()->Void, error: @escaping ()->Void) -> Void
}
