//
//  FeaturesDataSource.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureDataSource: NSObject, DataSource, UITableViewDelegate, UITableViewDataSource {

    private var data : [ViewModel] = []
    
    // MARK: DataSource
    
    func update(start start: () -> Void, success: () -> Void, error: () -> Void) {
        
        start ()
        data = [
            FeatureAuthViewModel(),
            FeatureNotifViewModel(),
            FeaturePermViewModel(),
            FeatureEventViewModel()
        ]
    }
    
    // MARK: Table delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return data[indexPath.row].heightForRow()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return data[indexPath.row].representationAsRow(tableView)
    }
}
