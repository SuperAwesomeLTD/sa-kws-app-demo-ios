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
        submitButton.setTitle("add_app_data_submit".localized.uppercased(), for: UIControlState())
        
        submitButton.redButton()
        namePairTextField.kwsStyle()
        valuePairTextField.kwsStyle()
        valuePairTextField.keyboardType = UIKeyboardType.numberPad
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: KWSPopupNavigationBarProtocol
    
    func kwsPopupNavGetTitle() -> String {
        return "add_app_data_vc_title".localized
    }
    
    func kwsPopupNavDidPressOnClose() {
        dismiss(animated: true) {
            // flush
        }
    }

    @IBAction func submitButtonAction(_ sender: AnyObject) {
        
        let vc = self
        
        let name = namePairTextField.text
        let value = valuePairTextField.text
        let model = SetAppDataModel(name: name, value: value)
        
        if model.isValid() {
            
            SAActivityView.sharedManager().show()
            
            KWS.sdk().setAppData(model.getName(), withValue: model.getValue(), { (set) in
                
                SAActivityView.sharedManager().hide()
                
                if set {
                    
                    vc.dismiss(animated: true, completion: { 
                        NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.ADDED_APPDATA.rawValue), object: nil)
                    })
                    
                } else {
                    self.appDataError("add_app_data_popup_error_title".localized, "add_app_data_error_message".localized)
                }
                
            })
            
        } else {
            appDataError("add_app_data_popup_warning_title".localized, "add_app_data_warning_message".localized)
        }
    }
    
    func appDataError(_ title: String, _ message: String) {
        SAPopup.sharedManager().show(withTitle: title,
                                              andMessage: message,
                                              andOKTitle: "add_app_data_popup_dismiss_button".localized,
                                              andNOKTitle: nil,
                                              andTextField: false,
                                              andKeyboardTyle: .decimalPad,
                                              andPressed: nil)
    }
}
