//
//  AppDataGetControllerViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import KWSiOSSDKObjC
import SAUtils

class GetAppDataController: KWSBaseController {

    // outlets
    @IBOutlet weak var appDataTable: UITableView!
    @IBOutlet weak var addButton: KWSRedButton!
    
    // data source
    var dataSource: Observable<RxDataSource>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set data source
        dataSource = RxKWS.getAppData()
            .map { (appData: KWSAppData) -> GetAppDataViewModel in
                return GetAppDataViewModel (appData.name, appData.value)
            }
            .toArray()
            .do(onNext: { (elems) in
                // do nothing
            }, onError: { (error) in
                SAActivityView.sharedManager().hide()
            }, onCompleted: { 
                SAActivityView.sharedManager().hide()
            }, onSubscribe: { 
                SAActivityView.sharedManager().show()
            })
            .bindTable(appDataTable)
            .customiseRow(cellIdentifier: "GetAppDataRowId",
                          cellType: GetAppDataViewModel.self,
                          cellHeight: 44)
            { (model, cell) in
                            
                let cell = cell as? GetAppDataRow
                let model = model as? GetAppDataViewModel
                
                cell?.nameLabel.text = model?.name
                cell?.valueLabel.text = model?.value
                
            }
        
        // button tap
        addButton.rx
            .tap
            .flatMap { () -> Observable <UIViewController> in
                return self.rxSeque(withIdentifier: "GetAppDataToSetAppDataSegue")
            }
            .subscribe(onNext: { (controller) in
                // do nothing
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataSource?.update().addDisposableTo(disposeBag)
    }
}
