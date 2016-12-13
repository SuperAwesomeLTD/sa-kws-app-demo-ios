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
    
    // data source
    private var dataSource: RxDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "user_vc_title".localized
        
        logoutButton.setTitle("user_logout".localized.uppercased(), for: UIControlState())
        
        // get the user data
        RxKWS.getUser()
            .map { (user: KWSUser?) -> [ViewModel] in
                
                var array: [ViewModel] = []
                
                if let user = user {
                    
                    array.append(UserHeaderViewModel(title: user.username))
                    array.append(UserRowViewModel(item: "user_row_details_first_name".localized, value: user.firstName as AnyObject?))
                    array.append(UserRowViewModel(item: "user_row_details_last_name".localized, value: user.lastName as AnyObject?))
                    array.append(UserRowViewModel(item: "user_row_details_birth_date".localized, value: user.dateOfBirth as AnyObject?))
                    array.append(UserRowViewModel(item: "user_row_details_email".localized, value: user.email as AnyObject?))
                    array.append(UserRowViewModel(item: "user_row_details_phone".localized, value: user.phoneNumber as AnyObject?))
                    array.append(UserRowViewModel(item: "user_row_details_gender".localized, value: user.gender as AnyObject?))
                    array.append(UserRowViewModel(item: "user_row_details_language".localized, value: user.language as AnyObject?))
                    
                    if let address = user.address {
                        array.append(UserHeaderViewModel(title: "user_header_address".localized))
                        array.append(UserRowViewModel(item: "user_row_address_street".localized, value: address.street as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_address_city".localized, value: address.city as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_address_post_code".localized, value: address.postCode as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_address_country".localized, value: address.country as AnyObject?))
                    }
                    
                    if let points = user.points {
                        array.append(UserHeaderViewModel(title: "user_header_points".localized))
                        array.append(UserRowViewModel(item: "user_row_points_received".localized, value: points.totalReceived as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_points_total".localized, value: points.total as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_points_app".localized, value: points.totalPointsReceivedInCurrentApp as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_points_available".localized, value: points.availableBalance as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_points_pending".localized, value: points.pending as AnyObject?))
                    }
                    
                    if let permissions = user.applicationPermissions {
                        array.append(UserHeaderViewModel(title: "user_header_perm".localized))
                        array.append(UserRowViewModel(item: "user_row_perm_address".localized, value: permissions.accessAddress as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_perm_phone".localized, value: permissions.accessPhoneNumber as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_perm_first_name".localized, value: permissions.accessFirstName as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_perm_last_name".localized, value: permissions.accessLastName as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_perm_email".localized, value: permissions.accessEmail as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_perm_street".localized, value: permissions.accessStreetAddress as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_perm_city".localized, value: permissions.accessCity as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_perm_post_code".localized, value: permissions.accessPostalCode as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_perm_country".localized, value: permissions.accessCountry as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_perm_notifications".localized, value: permissions.sendPushNotification as AnyObject?))
                        array.append(UserRowViewModel(item: "user_row_perm_newsletter".localized, value: permissions.sendNewsletter as AnyObject?))
                    }
                }
                
                return array
            }
            .subscribe(onNext: { (models: [ViewModel]) in
              
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
