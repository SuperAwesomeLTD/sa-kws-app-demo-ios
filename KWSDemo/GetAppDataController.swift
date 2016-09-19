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
    private var dataSource: GetAppDataDataSource!
    private var spinnerM: SAActivityView!
    private var popupM: SAPopup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
        
        addButton.setTitle("get_app_data_add_button".localized.uppercaseString, forState: UIControlState.Normal)
        
        addButton.redButton()
        spinnerM = SAActivityView.sharedManager()
        popupM = SAPopup.sharedManager()
        dataSource = GetAppDataDataSource()
        appDataTable.dataSource = dataSource
        appDataTable.delegate = dataSource
        loadDataSource()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadDataSource), name: Notifications.ADDED_APPDATA.rawValue, object: nil)
    }
    
    func loadDataSource() {
        dataSource.update(start: {
            self.spinnerM.showActivityView()
            }, success: {
                self.spinnerM.hideActivityView()
                self.appDataTable.reloadData()
            }, error: {
                self.spinnerM.hideActivityView()
                self.popupM.showWithTitle(
                    "get_app_data_popup_error_title".localized,
                    andMessage: "get_app_data_popup_error_message".localized,
                    andOKTitle: "get_app_data_popup_dismiss_button".localized,
                    andNOKTitle: nil,
                    andTextField: false,
                    andKeyboardTyle: UIKeyboardType.Default,
                    andPressed: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .Black
    }

    @IBAction func addNewNameValuePairAction(sender: AnyObject) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("SetAppDataNavControllerId")
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: KWSPopupNavigationBarProtocol
    
    func kwsPopupNavGetTitle() -> String {
        return "get_app_data_vc_title".localized
    }
    
    func kwsPopupNavDidPressOnClose() {
        dismissViewControllerAnimated(true) {
            // flush
        }
    }
}
