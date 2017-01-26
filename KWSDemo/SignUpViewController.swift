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
    @IBOutlet weak var reloadUsername: UIButton!
    
    // current model
    private let countrySubject: PublishSubject <String?> = PublishSubject<String?>()
    private var currentModel: SignUpModel = SignUpModel.createEmpty()
    private var usernameTxt: ControlProperty<String>!
    
    // delegate
    public var delegate: SignUpProtocol?
    
    // touch
    private var touch: UIGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "page_signup_title".localized
        
        usernameTextView.placeholder = "page_signup_textfield_username_placeholder".localized
        password1TextView.placeholder = "page_signup_textfield_password1_placeholder".localized
        password2TextView.placeholder = "page_signup_textfield_password2_placeholder".localized
        parentEmailTextView.placeholder = "page_signup_textfield_email_placeholder".localized
        countryButton.setTitle("page_signup_button_country".localized, for: .normal)
        yearTextView.placeholder = "page_signup_textfield_year_placeholder".localized
        monthTextView.placeholder = "page_signup_textfield_month_placeholder".localized
        dayTextView.placeholder = "page_signup_textfield_day_placeholder".localized
        submitButton.setTitle("page_signup_button_submit".localized.uppercased(), for: .normal)
        
        // determine if the submit button should be enabled or not
        Observable
            .combineLatest(usernameTextView.rx.text.orEmpty,
                           password1TextView.rx.text.orEmpty,
                           password2TextView.rx.text.orEmpty,
                           parentEmailTextView.rx.text.orEmpty,
                           yearTextView.rx.text.orEmpty,
                           monthTextView.rx.text.orEmpty,
                           dayTextView.rx.text.orEmpty,
                           countrySubject.asObserver().startWith(nil))
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
            .subscribe(onNext: { (Void) in
                
                self.performSegue(withIdentifier: "SignUpToCountrySegue", sender: self)
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
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else if status == KWSCreateUserStatus.duplicateUsername {
                    self.signUpError()
                }
                else {
                    self.networkError()
                }
            })
            .addDisposableTo(disposeBag)
    
        // for the reload username
        reloadUsername.rx
            .tap
            .startWith(())
            .asObservable()
            .flatMap({ () -> Observable<String?> in
                return RxKWS.getRandomName()
            })
            .subscribe(onNext: { (name) in
                self.usernameTextView.text = name
            })
            .addDisposableTo(disposeBag)
        
        // the touch gesture recogniser
        touch = UITapGestureRecognizer ()
        touch?.rx.event.asObservable()
            .subscribe(onNext: { (event) in
                self.usernameTextView.resignFirstResponder()
                self.password1TextView.resignFirstResponder()
                self.password2TextView.resignFirstResponder()
                self.parentEmailTextView.resignFirstResponder()
                self.yearTextView.resignFirstResponder()
                self.monthTextView.resignFirstResponder()
                self.dayTextView.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
        self.view.addGestureRecognizer(touch!)
        
        // become first responder
        usernameTextView.becomeFirstResponder()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func signUpError() {
        SAAlert.getInstance().show(withTitle: "page_signup_popup_error_create_title".localized,
                                   andMessage: "page_signup_popup_error_create_message".localized,
                                   andOKTitle: "page_signup_popup_error_create_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .decimalPad,
                                   andPressed: nil)
    }
    
    func networkError () {
        SAAlert.getInstance().show(withTitle: "page_signup_popup_error_network_title".localized,
                                   andMessage: "page_signup_popup_error_network_message".localized,
                                   andOKTitle: "page_signup_popup_error_network_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .decimalPad,
                                   andPressed: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CountryController {
            destination.delegate = self
        }
    }
}
