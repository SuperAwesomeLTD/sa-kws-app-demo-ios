//
//  FeaturesViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeaturesViewController: UIViewController, UITableViewDelegate {

    // table view
    @IBOutlet weak var tableView: UITableView!
    
    // data source
    var dataSource: FeaturesDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "AuthTableViewCell", bundle: nil), forCellReuseIdentifier: "AuthTableViewCellId")
        tableView.registerNib(UINib(nibName: "NotifTableViewCell", bundle: nil), forCellReuseIdentifier: "NotifTableViewCellId")
        
        dataSource = FeaturesDataSource()
        if let dataSource = dataSource {
            tableView.dataSource = dataSource
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // <UITableViewDelegate>
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 298 : 248
    }
}
