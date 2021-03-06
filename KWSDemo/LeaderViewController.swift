//
//  LeaderboardViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import KWSiOSSDKObjC
import SAUtils

class LeaderViewController: KWSBaseController {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleText: UILabel!
    
    // data source
    private var dataSource: RxDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = "page_leader_title".localized
        
        RxKWS.getLeaderboard()
            .map { (leader: KWSLeader) -> ViewModel in
                return LeaderRowViewModel (leader.rank, leader.score, leader.user)
            }
            .toArray()
            .map { (models: [ViewModel]) -> [ViewModel] in
                return [LeaderHeaderViewModel()] + models
            }
            .subscribe(onNext: { (viewModels: [ViewModel]) in
              
                // create data source
                self.dataSource = RxDataSource
                    .bindTable(self.tableView)
                    .customiseRow(cellIdentifier: LeaderHeader.Identifier,
                                  cellType: LeaderHeaderViewModel.self,
                                  cellHeight: 44)
                    { (model, cell) in
                        
                        let cell = cell as? LeaderHeader
                        let model = model as? LeaderHeaderViewModel
                        
                        cell?.rankLabel.text = model?.col1title
                        cell?.usernameLabel.text = model?.col2title
                        cell?.pointsLabel.text = model?.col3title
                        
                    }
                    .customiseRow(cellIdentifier: LeaderRow.Identifier,
                                  cellType: LeaderRowViewModel.self,
                                  cellHeight: 44)
                    { (model, cell) in
                        
                        let cell = cell as? LeaderRow
                        let model = model as? LeaderRowViewModel
                        
                        cell?.RankLabel.text = model?.rank
                        cell?.UsernameLabel.text = model?.username
                        cell?.PointsLabel.text = model?.score
                        
                }
                
                // update
                self.dataSource?.update(viewModels)
                
            })
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
