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
import KWSiOSSDKObjC
import SAUtils

class GetAppDataController: KWSBaseController {

    // outlets
    @IBOutlet weak var appDataTable: UITableView!
    @IBOutlet weak var addButton: KWSRedButton!
    
    @IBOutlet weak var titleText: UILabel!
    
    // data source
    private var dataSource: RxDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = "page_getappdata_title".localized
        addButton.setTitle("page_getappdata_button_add".localized.uppercased(), for: .normal)
        
        // button tap
        addButton.rx
            .tap
            .subscribe(onNext: { (Void) in
                
                self.performSegue(withIdentifier: "GetAppDataToSetAppDataSegue", sender: self)
            
            })
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set data source
        RxKWS.getAppData()
            .map { (appData: KWSAppData) -> GetAppDataViewModel in
                return GetAppDataViewModel (appData.name, appData.value)
            }
            .toArray()
            .subscribe(onNext: { (models: [GetAppDataViewModel]) in
                
                self.dataSource = RxDataSource
                    .bindTable(self.appDataTable)
                    .customiseRow(cellIdentifier: "GetAppDataRowId",
                                  cellType: GetAppDataViewModel.self,
                                  cellHeight: 44)
                    { (model, cell) in
                        
                        let cell = cell as? GetAppDataRow
                        let model = model as? GetAppDataViewModel
                        
                        cell?.nameLabel.text = model?.name
                        cell?.valueLabel.text = model?.value
                        
                }
                
                self.dataSource?.update(models)
                
            }, onError: { (error) in
                self.networkError()
            })
            .addDisposableTo(disposeBag)
    }
    
    func networkError () {
        SAAlert.getInstance().show(withTitle: "page_getappdata_popup_error_network_title".localized,
                                   andMessage: "page_getappdata_popup_error_network_message".localized,
                                   andOKTitle: "page_getappdata_popup_error_network_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .decimalPad,
                                   andPressed: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
