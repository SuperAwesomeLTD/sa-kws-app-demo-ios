//
//  SetAppDataController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class SetAppDataController: UIViewController, KWSPopupNavigationBarProtocol {

    // outlets
    @IBOutlet weak var namePairTextField: UITextField!
    @IBOutlet weak var valuePairTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
        
        namePairTextField.placeholder = "add_app_data_name_placeholder".localized
        valuePairTextField.placeholder = "add_app_data_value_placeholder".localized
        submitButton.setTitle("add_app_data_submit".localized.uppercaseString, forState: UIControlState.Normal)
        
        submitButton.redButton()
        namePairTextField.kwsStyle()
        valuePairTextField.kwsStyle()
        valuePairTextField.keyboardType = UIKeyboardType.NumberPad
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .Black
    }
    
    // MARK: KWSPopupNavigationBarProtocol
    
    func kwsPopupNavGetTitle() -> String {
        return "add_app_data_vc_title".localized
    }
    
    func kwsPopupNavDidPressOnClose() {
        dismissViewControllerAnimated(true) {
            // flush
        }
    }

    @IBAction func submitButtonAction(sender: AnyObject) {
        
        let vc = self
        
        let name = namePairTextField.text
        let value = valuePairTextField.text
        let model = SetAppDataModel(name: name, value: value)
        
        if model.isValid() {
            
            SAActivityView.sharedManager().showActivityView()
            
            KWS.sdk().setAppData(model.getName(), withValue: model.getValue(), { (set) in
                
                SAActivityView.sharedManager().hideActivityView()
                
                if set {
                    
                    vc.dismissViewControllerAnimated(true, completion: { 
                        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.ADDED_APPDATA.rawValue, object: nil)
                    })
                    
                } else {
                    self.appDataError("add_app_data_popup_error_title".localized, "add_app_data_error_message".localized)
                }
                
            })
            
        } else {
            appDataError("add_app_data_popup_warning_title".localized, "add_app_data_warning_message".localized)
        }
    }
    
    func appDataError(title: String, _ message: String) {
        SAPopup.sharedManager().showWithTitle(title,
                                              andMessage: message,
                                              andOKTitle: "add_app_data_popup_dismiss_button".localized,
                                              andNOKTitle: nil,
                                              andTextField: false,
                                              andKeyboardTyle: .DecimalPad,
                                              andPressed: nil)
    }
}
