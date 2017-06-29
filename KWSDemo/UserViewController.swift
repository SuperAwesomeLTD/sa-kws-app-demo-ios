//
//  LogOutViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 27/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import KWSiOSSDKObjC
import RxCocoa
import RxSwift
import SAUtils

// vc
class UserViewController: KWSBaseController {
    
    // outlets
    @IBOutlet weak var logoutButton: KWSRedButton!
    @IBOutlet weak var userDetailsTableView: UITableView!
    
    @IBOutlet weak var titleText: UILabel!
    
    // data source
    private var dataSource: RxDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = "page_user_title".localized
        
        logoutButton.setTitle("page_user_button_logout".localized.uppercased(), for: UIControlState())
        
        // get the user data
        RxKWS.getUser()
            .map { (user: KWSUser?) -> [ViewModel] in
                
                var array: [ViewModel] = []
                
                if let user = user {
                    
                    array.append(UserHeaderViewModel(title: user.username))
                    array.append(UserRowViewModel(item: "page_user_row_details_first_name_title".localized, value: user.firstName as AnyObject?))
                    array.append(UserRowViewModel(item: "page_user_row_details_last_name_title".localized, value: user.lastName as AnyObject?))
                    array.append(UserRowViewModel(item: "page_user_row_details_birth_date_title".localized, value: user.dateOfBirth as AnyObject?))
                    array.append(UserRowViewModel(item: "page_user_row_details_email_title".localized, value: user.email as AnyObject?))
                    array.append(UserRowViewModel(item: "page_user_row_details_phone_title".localized, value: user.phoneNumber as AnyObject?))
                    array.append(UserRowViewModel(item: "page_user_row_details_gender_title".localized, value: user.gender as AnyObject?))
                    array.append(UserRowViewModel(item: "page_user_row_details_language_title".localized, value: user.language as AnyObject?))
                    
                    if let address = user.address {
                        array.append(UserHeaderViewModel(title: "page_user_header_address".localized))
                        array.append(UserRowViewModel(item: "page_user_row_address_street_title".localized, value: address.street as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_address_city_title".localized, value: address.city as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_address_post_code_title".localized, value: address.postCode as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_address_country_title".localized, value: address.country as AnyObject?))
                    }
                    
                    if let points = user.points {
                        array.append(UserHeaderViewModel(title: "page_user_header_points".localized))
                        array.append(UserRowViewModel(item: "page_user_row_points_received_title".localized, value: points.totalReceived as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_points_total_title".localized, value: points.total as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_points_app_title".localized, value: points.totalPointsReceivedInCurrentApp as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_points_available_title".localized, value: points.availableBalance as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_points_pending_title".localized, value: points.pending as AnyObject?))
                    }
                    
                    if let permissions = user.applicationPermissions {
                        array.append(UserHeaderViewModel(title: "page_user_header_permissions".localized))
                        array.append(UserRowViewModel(item: "page_user_row_perm_address_title".localized, value: permissions.accessAddress as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_perm_phone_title".localized, value: permissions.accessPhoneNumber as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_perm_first_name_title".localized, value: permissions.accessFirstName as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_perm_last_name_title".localized, value: permissions.accessLastName as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_perm_email_title".localized, value: permissions.accessEmail as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_perm_street_title".localized, value: permissions.accessStreetAddress as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_perm_city_title".localized, value: permissions.accessCity as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_perm_post_code_title".localized, value: permissions.accessPostalCode as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_perm_country_title".localized, value: permissions.accessCountry as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_perm_notifications_title".localized, value: permissions.sendPushNotification as AnyObject?))
                        array.append(UserRowViewModel(item: "page_user_row_perm_newsletter_title".localized, value: permissions.sendNewsletter as AnyObject?))
                    }
                }
                
                return array
            }
            .subscribe(onNext: { (models: [ViewModel]) in
              
                // if models has at least some data, go ahead!
                if models.count > 0 {
                    
                    // create data source
                    self.dataSource = RxDataSource
                        .bindTable(self.userDetailsTableView)
                        .customiseRow(cellIdentifier: UserHeader.Identifier,
                                      cellType: UserHeaderViewModel.self,
                                      cellHeight: 44)
                        { (model, cell) in
                            
                            let cell = cell as? UserHeader
                            let model = model as? UserHeaderViewModel
                            
                            cell?.headerTitle.text = model?.title
                            
                        }
                        .customiseRow(cellIdentifier: UserRow.Identifier,
                                      cellType: UserRowViewModel.self,
                                      cellHeight: 44)
                        { (model, cell) in
                            
                            let cell = cell as? UserRow
                            let model = model as? UserRowViewModel
                            
                            cell?.titleLabel.text = model?.item
                            cell?.valueLabel.text = model?.value
                            cell?.valueLabel.textColor = model?.valueColor
                            
                    }
                    
                    // update
                    self.dataSource?.update(models)
                    
                }
                // if models doesn't have anything, it means the user could 
                // not be loaded OK - so show network error
                else {
                    self.networkError()
                }
                
            })
            .addDisposableTo(disposeBag)
        
        // tap to logout
        logoutButton.rx
            .tap
            .subscribe ( { (Void) in
                KWS.sdk().logoutUser()
                _ = self.navigationController?.popViewController(animated: true)
            })
            .addDisposableTo(disposeBag)
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func networkError () {
        SAAlert.getInstance().show(withTitle: "page_user_popup_error_network_title".localized,
                                   andMessage: "page_user_popup_error_network_message".localized,
                                   andOKTitle: "page_user_popup_error_network_ok_button".localized,
                                   andNOKTitle: nil,
                                   andTextField: false,
                                   andKeyboardTyle: .decimalPad,
                                   andPressed: nil)
    }
}
