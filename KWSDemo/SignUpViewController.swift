//
//  SignUpViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

// vc
class SignUpViewController: UIViewController, KWSPopupNavigationBarProtocol {

    // outlets
    @IBOutlet weak var usernameTextView: UITextField!
    @IBOutlet weak var password1TextView: UITextField!
    @IBOutlet weak var password2TextView: UITextField!
    @IBOutlet weak var yearTextView: UITextField!
    @IBOutlet weak var monthTextView: UITextField!
    @IBOutlet weak var dayTextView: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // variables
    private var username: String?
    private var password1: String?
    private var password2: String?
    private var year: Int?
    private var month: Int?
    private var day: Int?
    private var passwordsMatch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
        
        usernameTextView.placeholder = "sign_up_username_placeholder".localized
        password1TextView.placeholder = "sign_up_password1_placeholder".localized
        password2TextView.placeholder = "sign_up_password2_placeholder".localized
        yearTextView.placeholder = "sign_up_year_placeholder".localized
        monthTextView.placeholder = "sign_up_month_placeholder".localized
        dayTextView.placeholder = "sign_up_day_placeholder".localized
        submitButton.setTitle("sign_up_submit".localized.uppercaseString, forState: UIControlState.Normal)
        
        // customize
        submitButton.redButton()
        usernameTextView.kwsStyle()
        password1TextView.secureTextEntry = true
        password1TextView.kwsStyle()
        password2TextView.secureTextEntry = true
        password2TextView.kwsStyle()
        monthTextView.keyboardType = .NumberPad
        monthTextView.kwsStyle()
        yearTextView.keyboardType = .NumberPad
        yearTextView.kwsStyle()
        dayTextView.keyboardType = .NumberPad
        dayTextView.kwsStyle()
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // <KWSPopupNavigationBarProtocol>
    
    func kwsPopupNavGetTitle() -> String {
        return "sign_up_vc_title".localized
    }
    
    func kwsPopupNavDidPressOnClose() {
        resignAllResponders()
        dismissViewControllerAnimated(true) { 
            // flush
        }
    }
    
    // <Actions>
    
    @IBAction func submitAction(sender: AnyObject) {
        
        let vc = self
        
        // verify username
        if let text = usernameTextView.text where text != "" {
            username = text
        } else {
            signUpError("sign_up_popup_warning_title".localized, "sign_up_popup_warning_message_username".localized)
            return
        }
        
        // password 1
        if let text = password1TextView.text where text != "" && text.characters.count >= 8 {
            password1 = text
        } else {
            signUpError("sign_up_popup_warning_title".localized, "sign_up_popup_warning_message_password1".localized)
            return
        }
        
        // password 2
        if let text = password2TextView.text where text != "" && text.characters.count >= 8 {
            password2 = text
        } else {
            signUpError("sign_up_popup_warning_title".localized, "sign_up_popup_warning_message_password2".localized)
            return
        }
        
        // passwords must match
        if let password1 = password1, let password2 = password2 where password1 == password2 {
            passwordsMatch = true
        } else {
            signUpError("sign_up_popup_warning_title".localized, "sign_up_popup_warning_message_password12".localized)
            return
        }
        
        // year check
        if let text = yearTextView.text, let year = Int(text) where year > 1900 && year <= 2016 {
            self.year = year
        } else {
            signUpError("sign_up_popup_warning_title".localized, "sign_up_popup_warning_message_year".localized)
            return
        }
        
        // month check
        if let text = monthTextView.text, let month = Int(text) where month > 1 && month <= 12 {
            self.month = month
        } else {
            signUpError("sign_up_popup_warning_title".localized, "sign_up_popup_warning_message_month".localized)
            return
        }
        
        // day check
        if let text = dayTextView.text, let day = Int(text) where day > 1 && day <= 30 {
            self.day = day
        } else {
            signUpError("sign_up_popup_warning_title".localized, "sign_up_popup_warning_message_day".localized)
            return
        }
        
        // do a final check to see everything is in order
        if let username = username, let password = password1, let year = year, let month = month, let day = day where passwordsMatch == true {
            
            let postData = [
                "username": username,
                "password": password,
                "country": "US",
                "dateOfBirth": "\(year)-" + (month < 10 ? "0\(month)" : "\(month)") + "-" + (day < 10 ? "0\(day)" : "\(day)")
            ]
            let header = [
                "Content-Type":"application/json"
            ]
    
            // start loading
            resignAllResponders()
            SAActivityView.sharedManager().showActivityView()
            
            // send POST
            let network = SANetwork()
            network.sendPOST("https://kwsdemobackend.herokuapp.com/create", withQuery: [:], andHeader: header, andBody: postData, withResponse: { (code: Int, json: String!, success: Bool) in
                // hide this
                SAActivityView.sharedManager().hideActivityView()
                
                if (!success) {
                    self.signUpError("error_title".localized, "sign_up_popup_error_message".localized)
                } else {
                    
                    if code == 200 {
                        // get the model
                        let kwsmodel = KWSModel(jsonString: json)
                        kwsmodel.username = username
                        
                        // check if all is OK
                        if kwsmodel.status == 1 {
                            
                            // dismiss
                            vc.dismissViewControllerAnimated(true) {
                                // save user to singleton
                                KWSSingleton.sharedInstance.loginUser(kwsmodel)
                            }
                            
                        } else if kwsmodel.status == 0 {
                            self.signUpError("error_title".localized, "sign_up_popup_error_message".localized)
                        } else {
                            self.signUpError("error_title".localized, "sign_up_popup_error_message".localized)
                        }
                    } else {
                        self.signUpError("error_title".localized, "sign_up_popup_error_message".localized)
                    }
                }
            })
        } else {
            signUpError("error_title".localized, "sign_up_popup_error_message".localized)
        }
    }
    
    // <Private>
    func resignAllResponders () {
        usernameTextView.resignFirstResponder()
        password1TextView.resignFirstResponder()
        password2TextView.resignFirstResponder()
        yearTextView.resignFirstResponder()
        monthTextView.resignFirstResponder()
        dayTextView.resignFirstResponder()
    }
    
    func signUpError(title: String, _ message: String) {
        SAPopup.sharedManager().showWithTitle(title,
                                              andMessage: message,
                                              andOKTitle: "sign_up_popup_dismiss_button".localized,
                                              andNOKTitle: nil,
                                              andTextField: false,
                                              andKeyboardTyle: .DecimalPad,
                                              andPressed: nil)
    }
}
