//
//  AppDataGetControllerViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class GetAppDataController: UIViewController, KWSPopupNavigationBarProtocol {

    @IBOutlet weak var appDataTable: UITableView!
    @IBOutlet weak var addButton: UIButton!
    fileprivate var dataSource: GetAppDataDataSource!
    fileprivate var spinnerM: SAActivityView!
    fileprivate var popupM: SAPopup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
        
        addButton.setTitle("get_app_data_add_button".localized.uppercased(), for: UIControlState())
        
        addButton.redButton()
        spinnerM = SAActivityView.sharedManager()
        popupM = SAPopup.sharedManager()
        dataSource = GetAppDataDataSource()
        appDataTable.dataSource = dataSource
        appDataTable.delegate = dataSource
        loadDataSource()
        NotificationCenter.default.addObserver(self, selector: #selector(loadDataSource), name: NSNotification.Name(rawValue: Notifications.ADDED_APPDATA.rawValue), object: nil)
    }
    
    func loadDataSource() {
        dataSource.update(start: {
            self.spinnerM.show()
            }, success: {
                self.spinnerM.hide()
                self.appDataTable.reloadData()
            }, error: {
                self.spinnerM.hide()
                self.popupM.show(
                    withTitle: "get_app_data_popup_error_title".localized,
                    andMessage: "get_app_data_popup_error_message".localized,
                    andOKTitle: "get_app_data_popup_dismiss_button".localized,
                    andNOKTitle: nil,
                    andTextField: false,
                    andKeyboardTyle: UIKeyboardType.default,
                    andPressed: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }

    @IBAction func addNewNameValuePairAction(_ sender: AnyObject) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SetAppDataNavControllerId")
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: KWSPopupNavigationBarProtocol
    
    func kwsPopupNavGetTitle() -> String {
        return "get_app_data_vc_title".localized
    }
    
    func kwsPopupNavDidPressOnClose() {
        dismiss(animated: true) {
            // flush
        }
    }
}
