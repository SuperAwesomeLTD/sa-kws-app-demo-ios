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
import RxGesture
import KWSiOSSDKObjC
import SAUtils

class LoginController: KWSBaseController, SignUpProtocol {

    // outlets
    @IBOutlet weak var usernameTextField: KWSTextField!
    @IBOutlet weak var passwordTextField: KWSTextField!
    @IBOutlet weak var createNewUserButton: UIButton!
    @IBOutlet weak var loginButton: KWSRedButton!
    
    // model
    private var currentModel = LoginModel.createEmpty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add text
        usernameTextField.placeholder = "login_username_placeholder".localized
        passwordTextField.placeholder = "login_password_placeholder".localized
        createNewUserButton.setTitle("login_button_create".localized.uppercased(), for: .normal)
        loginButton.setTitle("login_button_login".localized.uppercased(), for: .normal)
        
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
                self.loginButton.backgroundColor = isValid ? UIColorFromHex(0xED1C24) : UIColor.lightGray
            })
            .addDisposableTo(disposeBag)
        
        // add actions
        createNewUserButton.rx
            .tap
            .flatMap { () -> Observable <UIViewController> in
                return self.rxSeque(withIdentifier: "LoginToSignUpSegue")
            }
            .subscribe(onNext: { (vc) in
                if let dest = vc as? KWSNavigationController,
                    let destination = dest.viewControllers.first as? SignUpViewController {
                    destination.delegate = self
                }
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
                    self.dismiss(animated: true, completion: nil)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didSignUp() {
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginError () {
        SAPopup.sharedManager().show(withTitle: "login_popup_error_title".localized,
                                     andMessage: "login_popup_error_message".localized,
                                     andOKTitle: "login_popup_dismiss_button".localized,
                                     andNOKTitle: nil,
                                     andTextField: false,
                                     andKeyboardTyle: .decimalPad,
                                     andPressed: nil)
    }
    
    func networkError () {
        SAPopup.sharedManager().show(withTitle: "login_popup_error_network_title".localized,
                                     andMessage: "login_popup_error_message".localized,
                                     andOKTitle: "login_popup_error_network_message".localized,
                                     andNOKTitle: nil,
                                     andTextField: false,
                                     andKeyboardTyle: .decimalPad,
                                     andPressed: nil)
    }
}
