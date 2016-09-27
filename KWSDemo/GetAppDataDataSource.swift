//
//  GetAppDataDataSource.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class GetAppDataDataSource: NSObject, DataSource, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate var rows: [ViewModel] = []
    
    // MARK: DataSourceProtocol
    
    internal func update(start: @escaping () -> Void, success: @escaping () -> Void, error: @escaping () -> Void) {
        
        KWS.sdk().getAppData { (appdata: [KWSAppData]?) in
            
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rows[(indexPath as NSIndexPath).row].heightForRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return rows[(indexPath as NSIndexPath).row].representationAsRow(tableView)
    }
    
}
