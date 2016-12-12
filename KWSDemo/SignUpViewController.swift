//
//  SignUpViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SAUtils
import KWSiOSSDKObjC

protocol SignUpProtocol {
    func didSignUp ()
}

// vc
class SignUpViewController: KWSBaseController, CountryProtocol  {

    // outlets
    @IBOutlet weak var usernameTextView: KWSTextField!
    @IBOutlet weak var password1TextView: KWSTextField!
    @IBOutlet weak var password2TextView: KWSTextField!
    @IBOutlet weak var parentEmailTextView: KWSTextField!
    @IBOutlet weak var yearTextView: KWSTextField!
    @IBOutlet weak var monthTextView: KWSTextField!
    @IBOutlet weak var dayTextView: KWSTextField!
    @IBOutlet weak var submitButton: KWSRedButton!
    @IBOutlet weak var countryButton: KWSCountryButton!
    @IBOutlet weak var countryIcon: UIImageView!
    
    // current model
    private let countrySubject: PublishSubject <String?> = PublishSubject<String?>()
    private var currentModel: SignUpModel = SignUpModel.createEmpty()
    
    // delegate
    public var delegate: SignUpProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextView.placeholder = "sign_up_username_placeholder".localized
        password1TextView.placeholder = "sign_up_password1_placeholder".localized
        password2TextView.placeholder = "sign_up_password2_placeholder".localized
        parentEmailTextView.placeholder = "sign_up_parent_email_paceholder".localized
        yearTextView.placeholder = "sign_up_year_placeholder".localized
        monthTextView.placeholder = "sign_up_month_placeholder".localized
        dayTextView.placeholder = "sign_up_day_placeholder".localized
        submitButton.setTitle("sign_up_submit".localized.uppercased(), for: .normal)
        countryButton.setTitle("sign_up_country_placeholder".localized, for: .normal)
        
        // determine if the submit button should be enabled or not
        Observable
            .combineLatest(usernameTextView.rx.text.orEmpty,
                           password1TextView.rx.text.orEmpty,
                           password2TextView.rx.text.orEmpty,
                           parentEmailTextView.rx.text.orEmpty,
                           yearTextView.rx.text.orEmpty,
                           monthTextView.rx.text.orEmpty,
                           dayTextView.rx.text.orEmpty,
                           countrySubject.asObserver())
            { (username, password1, password2, parentEmail, year, month, day, isoCode) -> SignUpModel in
                return SignUpModel(withUsername: username,
                                   andPassword1: password1,
                                   andPassword2: password2,
                                   andParentEmail: parentEmail,
                                   andYear: year,
                                   andMonth: month,
                                   andDay: day,
                                   andCountry: isoCode)
            }
            .do(onNext: { (signUpModel) in
                self.currentModel = signUpModel
            })
            .map { (signUpModel) -> Bool in
                return signUpModel.isValid()
            }
            .subscribe(onNext: { (isValid) in
                self.submitButton.isEnabled = isValid
                self.submitButton.backgroundColor = isValid ? UIColorFromHex(0xED1C24) : UIColor.lightGray
            })
            .addDisposableTo(disposeBag)
        
        // determine if the text field border should be red or gray
        usernameTextView.rx
            .controlEvent(.editingDidEnd)
            .map { () -> Bool in
                return self.currentModel.isUserOK()
            }
            .subscribe(onNext: { (isValid) in
                self.usernameTextView.setRedOrGrayBorder(isValid)
            })
            .addDisposableTo(disposeBag)
        
        password1TextView.rx
            .controlEvent(.editingDidEnd)
            .map { () -> Bool in
                return self.currentModel.isPassword1OK()
            }
            .subscribe(onNext: { (isValid) in
                self.password1TextView.setRedOrGrayBorder(isValid)
            })
            .addDisposableTo(disposeBag)
        
        password2TextView.rx
            .controlEvent(.editingDidEnd)
            .map { () -> Bool in
                return self.currentModel.isPassword2OK() && self.currentModel.arePasswordsSame()
            }
            .subscribe(onNext: { (isValid) in
                self.password2TextView.setRedOrGrayBorder(isValid)
            })
            .addDisposableTo(disposeBag)
        
        parentEmailTextView.rx
            .controlEvent(.editingDidEnd)
            .map { () -> Bool in
                return self.currentModel.isParentEmailOK()
            }
            .subscribe(onNext: { (isValid) in
                self.parentEmailTextView.setRedOrGrayBorder(isValid)
            })
            .addDisposableTo(disposeBag)
        
        yearTextView.rx
            .controlEvent(.editingDidEnd)
            .map { () -> Bool in
                return self.currentModel.isYearOK()
            }
            .subscribe(onNext: { (isValid) in
                self.yearTextView.setRedOrGrayBorder(isValid)
            })
            .addDisposableTo(disposeBag)
        
        monthTextView.rx
            .controlEvent(.editingDidEnd)
            .map { () -> Bool in
                return self.currentModel.isMonthOK()
            }
            .subscribe(onNext: { (isValid) in
                self.monthTextView.setRedOrGrayBorder(isValid)
            })
            .addDisposableTo(disposeBag)
        
        dayTextView.rx
            .controlEvent(.editingDidEnd)
            .map { () -> Bool in
                return self.currentModel.isDayOK()
            }
            .subscribe(onNext: { (isValid) in
                self.dayTextView.setRedOrGrayBorder(isValid)
            })
            .addDisposableTo(disposeBag)
        
        // contry button
        countryButton.rx
            .tap
            .flatMap { () -> Observable <UIViewController> in
                return self.rxSeque(withIdentifier: "SignUpToCountrySegue")
            }
            .subscribe(onNext: { (vc) in
                if let vc = vc as? KWSNavigationController,
                    let destination = vc.viewControllers.first as? CountryController {
                    destination.delegate = self
                }
            })
            .addDisposableTo(disposeBag)
        
        // now the click
        submitButton.rx.tap
            // .skip (1)
            .flatMap { () -> Observable <KWSCreateUserStatus> in
                return RxKWS.signUp(withUsername: self.currentModel.getUsername(),
                                    andPassword: self.currentModel.getPassword(),
                                    andBirthdate: self.currentModel.getDate(),
                                    andCountryCode: self.currentModel.getISOCode(),
                                    andParentEmail: self.currentModel.getParentEmail())
            }
            .subscribe(onNext: { (status: KWSCreateUserStatus) in
                
                if status == KWSCreateUserStatus.success {
                    self.delegate?.didSignUp()
                    self.dismiss(animated: true, completion: nil)
                }
                else if status == KWSCreateUserStatus.duplicateUsername {
                    self.signUpError()
                }
                else {
                    self.networkError()
                }
            })
            .addDisposableTo(disposeBag)
        
        countrySubject.onNext(nil)
    }
    
    func didSelectCountry(isoCode: String, name: String, flag: UIImage) {
        countryButton.setTitle(name, for: .normal)
        countryIcon.image = flag
        countryButton.setTitleColor(UIColor.black, for: .normal)
        countrySubject.onNext(isoCode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func signUpError() {
        SAPopup.sharedManager().show(withTitle: "sign_up_popup_error_title".localized,
                                     andMessage: "sign_up_popup_warning_message_username".localized,
                                     andOKTitle: "sign_up_popup_dismiss_button".localized,
                                     andNOKTitle: nil,
                                     andTextField: false,
                                     andKeyboardTyle: .decimalPad,
                                     andPressed: nil)
    }
    
    func networkError () {
        SAPopup.sharedManager().show(withTitle: "sign_up_popup_error_title".localized,
                                     andMessage: "sign_up_popup_error_message".localized,
                                     andOKTitle: "sign_up_popup_dismiss_button".localized,
                                     andNOKTitle: nil,
                                     andTextField: false,
                                     andKeyboardTyle: .decimalPad,
                                     andPressed: nil)
    }
}
