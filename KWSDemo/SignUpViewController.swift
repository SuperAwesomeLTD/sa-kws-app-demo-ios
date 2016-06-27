//
//  SignUpViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

// protocol
protocol SignUpViewControllerProtocol {
    func signupViewControllerDidManageToSignUpUser()
}

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
    
    // delegate
    var delegate: SignUpViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
        
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
            KWSSimpleAlert.sharedInstance.show(vc, title: "Hey!", message: "Please specify a valid username.", button: "Got it!")
            return
        }
        
        // password 1
        if let text = password1TextView.text where text != "" && text.characters.count >= 8 {
            password1 = text
        } else {
            KWSSimpleAlert.sharedInstance.show(vc, title: "Hey!", message: "Please speficy a password (that is longer than 8 characters)", button: "Got it!")
            return
        }
        
        // password 2
        if let text = password2TextView.text where text != "" && text.characters.count >= 8 {
            password2 = text
        } else {
            KWSSimpleAlert.sharedInstance.show(vc, title: "Hey!", message: "Please make sure the two passwords match (and are both longer than 8 characters)", button: "Got it!")
            return
        }
        
        // passwords must match
        if let password1 = password1, let password2 = password2 where password1 == password2 {
            passwordsMatch = true
        } else {
            KWSSimpleAlert.sharedInstance.show(vc, title: "Hey!", message: "The two passwords you entered do not match.", button: "Got it!")
            return
        }
        
        // year check
        if let text = yearTextView.text, let year = Int(text) where year > 1900 && year <= 2016 {
            self.year = year
        } else {
            KWSSimpleAlert.sharedInstance.show(vc, title: "Hey!", message: "Please specify a valid birth year.", button: "Got it!")
            return
        }
        
        // month check
        if let text = monthTextView.text, let month = Int(text) where month > 1 && month <= 12 {
            self.month = month
        } else {
            KWSSimpleAlert.sharedInstance.show(vc, title: "Hey!", message: "Please specify a valid birth month.", button: "Got it!")
            return
        }
        
        // day check
        if let text = dayTextView.text, let day = Int(text) where day > 1 && day <= 30 {
            self.day = day
        } else {
            KWSSimpleAlert.sharedInstance.show(vc, title: "Hey!", message: "Please specify a valid birth day.", button: "Got it")
            return
        }
        
        // do a final check to see everything is in order
        if let username = username, let password = password1, let year = year, let month = month, let day = day where passwordsMatch == true {
            
            let postData = [
                "username": username,
                "password": password,
                "dateOfBirth": "\(year)-" + (month < 10 ? "0\(month)" : "\(month)") + "-" + (day < 10 ? "0\(day)" : "\(day)")
            ]
    
            // start loading
            resignAllResponders()
            KWSActivityView.sharedInstance.showActivityView()
            
            // send POST
            KWSNetworking.sendPOST("https://kwsdemobackend.herokuapp.com/create", token: "", body: postData) { (json: String!, code: Int) in
                
                // hide this
                KWSActivityView.sharedInstance.hideActivityView()
                
                if code == 200 {
                    // get the model
                    let kwsmodel = KWSModel(jsonString: json)
                    kwsmodel.username = username
                    
                    // check if all is OK
                    if kwsmodel.status == 1 {
                        
                        // save user to singleton
                        KWSSingleton.sharedInstance.setModel(kwsmodel)
                        
                        // dismiss
                        vc.dismissViewControllerAnimated(true) {
                            self.delegate?.signupViewControllerDidManageToSignUpUser()
                        }
                        
                    } else if kwsmodel.status == 0 {
                        KWSSimpleAlert.sharedInstance.show(vc, title: "Error", message: "The user \(username) already exists.", button: "Got it!")
                    } else {
                        KWSSimpleAlert.sharedInstance.show(vc, title: "Error", message: "Failed to sign up user.", button: "Got it!")
                    }
                } else {
                    KWSSimpleAlert.sharedInstance.show(vc, title: "Error", message: "Failed to sign up user.", button: "Got it!")
                }
            }
        } else {
            KWSSimpleAlert.sharedInstance.show(vc, title: "Error", message: "Failed to sign up user.", button: "Got it!")
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
}
