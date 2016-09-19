//
//  GetAppDataDataSource.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class GetAppDataDataSource: NSObject, DataSource, UITableViewDataSource, UITableViewDelegate {

    private var rows: [ViewModel] = []
    
    // MARK: DataSourceProtocol
    
    func update(start start: ()->Void, success: ()->Void, error: ()->Void) -> Void {
        
        start()
        
        KWS.sdk().getAppData { (appdata: [KWSAppData]!) in
            
            if let appdata = appdata {
        
                self.rows = appdata.map({ data -> ViewModel in
                    return GetAppDataViewModel(data.name, data.value)
                })
                
                success ()
            } else {
                error ()
            }
            
        }
    }
    
    // MARK: Table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rows[indexPath.row].heightForRow()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return rows[indexPath.row].representationAsRow(tableView)
    }
    
}
