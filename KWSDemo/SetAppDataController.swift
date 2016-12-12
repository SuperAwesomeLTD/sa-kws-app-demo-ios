//
//  SetAppDataController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import KWSiOSSDKObjC
import SAUtils

class SetAppDataController: KWSBaseController {

    // outlets
    @IBOutlet weak var namePairTextField: KWSTextField!
    @IBOutlet weak var valuePairTextField: KWSTextField!
    @IBOutlet weak var submitButton: KWSRedButton!
    
    // variables
    var currentModel: SetAppDataModel = SetAppDataModel.createEmpty()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        namePairTextField.placeholder = "add_app_data_name_placeholder".localized
        valuePairTextField.placeholder = "add_app_data_value_placeholder".localized
        submitButton.setTitle("add_app_data_submit".localized.uppercased(), for: UIControlState())

        // make sure we have a valid current model and the "submit" button
        // is enabled
        Observable
            .combineLatest(namePairTextField.rx.text.orEmpty,
                           valuePairTextField.rx.text.orEmpty)
            { (name, value) -> SetAppDataModel in
                
                return SetAppDataModel(name: name, value: value)
                
            }
            .do(onNext: { (appDataModel) in
                self.currentModel = appDataModel
            })
            .map { (model) -> Bool in
                return model.isValid()
            }
            .subscribe(onNext: { (isValid) in
                self.submitButton.isEnabled = isValid
                self.submitButton.backgroundColor = isValid ? UIColorFromHex(0xED1C24) : UIColor.lightGray
            })
            .addDisposableTo(disposeBag)
        
        // the button click
        submitButton.rx
            .tap
            .flatMap { () -> Observable <Bool> in
                return RxKWS.setAppData(name: self.currentModel.getName(), value: self.currentModel.getValue())
            }
            .subscribe(onNext: { (success) in
                
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.appDataError ()
                }
                
            })
            .addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func appDataError() {
        SAPopup.sharedManager().show(withTitle: "add_app_data_popup_error_title".localized,
                                     andMessage: "add_app_data_error_message".localized,
                                     andOKTitle: "add_app_data_popup_dismiss_button".localized,
                                     andNOKTitle: nil,
                                     andTextField: false,
                                     andKeyboardTyle: .decimalPad,
                                     andPressed: nil)
    }
}
