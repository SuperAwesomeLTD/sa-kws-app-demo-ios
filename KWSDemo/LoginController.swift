//
//  SignInController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 09/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KWSiOSSDKObjC
import SAUtils

class LoginController: KWSBaseController, SignUpProtocol {

    // outlets
    @IBOutlet weak var usernameTextField: KWSTextField!
    @IBOutlet weak var passwordTextField: KWSTextField!
    @IBOutlet weak var createNewUserButton: UIButton!
    @IBOutlet weak var loginButton: KWSRedButton!
    
    @IBOutlet weak var titleText: UILabel!
    
    // model
    private var currentModel = LoginModel.createEmpty()
    
    // touch
    private var touch: UIGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = "page_login_title".localized
        
        // add text
        usernameTextField.placeholder = "page_login_textfield_username_placeholder".localized
        passwordTextField.placeholder = "page_login_textfield_password_placeholder".localized
        loginButton.setTitle("page_login_button_login".localized.uppercased(), for: .normal)
        createNewUserButton.setTitle("page_login_button_create".localized.uppercased(), for: .normal)
        
        // add observable for button
        Observable
            .combineLatest(usernameTextField.rx.text.orEmpty,
                                 passwordTextField.rx.text.orEmpty)
            { (username, password) -> LoginModel in
                return LoginModel(username: username, password: password)
            }
            .do(onNext: { (model) in
                self.currentModel = model
            })
            .map { (model) -> Bool in
                return model.isValid()
            }
            .subscribe(onNext: { (isValid) in
                self.loginButton.isEnabled = isValid
                self.loginButton.backgroundColor = isValid ? UIColorFromHex(0x46237A) : UIColor.lightGray
            })
            .addDisposableTo(disposeBag)
        
        // add actions
        createNewUserButton.rx
            .tap
            .subscribe(onNext: { (Void) in
                
                self.performSegue(withIdentifier: "LoginToSignUpSegue", sender: self)
            
            })
            .addDisposableTo(disposeBag)
        
        // and click for the login button
        loginButton.rx
            .tap
            .flatMap { () -> Observable <KWSAuthUserStatus> in
                return RxKWS.login(username: self.currentModel.getUsername(),
                                   password: self.currentModel.getPassword())
            }
            .subscribe(onNext: { (status: KWSAuthUserStatus) in
                
                switch status {
                    
                case KWSAuthUserStatus.success:
                    _ = self.navigationController?.popViewController(animated: true)
                    break
                case KWSAuthUserStatus.invalidCredentials:
                    self.loginError()
                    break
                case KWSAuthUserStatus.networkError:
                    self.networkError()
                    break
                    
                }
                
            })
            .addDisposableTo(disposeBag)
        
        // the touch gesture recogniser
        touch = UITapGestureRecognizer ()
        touch?.rx.event.asObservable()
            .subscribe(onNext: { (event) in
                self.usernameTextField.resignFirstResponder()
                self.passwordTextField.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        self.view.addGestureRecognizer(touch!)
    }

    func didSignUp() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SignUpViewController {
            destination.delegate = self
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loginError () {
        SAAlert.getInstance().show(withTitle: "page_login_popup_error_auth_title".localized,
                                   andMessage: "page_login_popup_error_auth_message".localized,
                                   andOKTitle: "page_login_popup_error_auth_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .decimalPad,
                                   andPressed: nil)
    }
    
    func networkError () {
        SAAlert.getInstance().show(withTitle: "page_login_popup_error_network_title".localized,
                                   andMessage: "page_login_popup_error_network_message".localized,
                                   andOKTitle: "page_login_popup_error_network_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .decimalPad,
                                   andPressed: nil)
    }
}
