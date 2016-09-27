//
//  FeaturesDataSource.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureDataSource: NSObject, DataSource, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var data : [ViewModel] = []
    
    // MARK: DataSource
    
    internal func update(start: @escaping () -> Void, success: @escaping () -> Void, error: @escaping () -> Void) {
        start ()
        data = [
            FeatureAuthViewModel(),
            FeatureNotifViewModel(),
            FeaturePermViewModel(),
            FeatureEventViewModel(),
            FeatureInviteViewModel(),
            FeatureAppDataViewModel()
        ]
        
        success()
    }
    
    // MARK: Table delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data[(indexPath as NSIndexPath).row].heightForRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return data[(indexPath as NSIndexPath).row].representationAsRow(tableView)
    }
}
