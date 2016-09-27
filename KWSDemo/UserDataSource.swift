//
//  UserDataSource.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class UserDataSource: NSObject, DataSource, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate struct UserData {
        var header: ViewModel
        var rows: [ViewModel] = []
    }

    fileprivate var data: [UserData] = []
    
    // MARK: DataSourceProtocol
    
    internal func update(start: @escaping () -> Void, success: @escaping () -> Void, error: @escaping () -> Void) {
        // start
        start()
        
        // load data
        KWS.sdk().getUser { (user: KWSUser?) in
            
            // perform operations on data
            if let user = user {
                
                self.data.append(UserData(header: UserHeaderViewModel(title: user.username), rows: [
                    UserRowViewModel(item: "user_row_details_first_name".localized, value: user.firstName as AnyObject?),
                    UserRowViewModel(item: "user_row_details_last_name".localized, value: user.lastName as AnyObject?),
                    UserRowViewModel(item: "user_row_details_birth_date".localized, value: user.dateOfBirth as AnyObject?),
                    UserRowViewModel(item: "user_row_details_email".localized, value: user.email as AnyObject?),
                    UserRowViewModel(item: "user_row_details_phone".localized, value: user.phoneNumber as AnyObject?),
                    UserRowViewModel(item: "user_row_details_gender".localized, value: user.gender as AnyObject?),
                    UserRowViewModel(item: "user_row_details_language".localized, value: user.language as AnyObject?)
                    ]))
                
                if let address = user.address {
                    self.data.append(UserData(header: UserHeaderViewModel(title: "user_header_address".localized), rows: [
                        UserRowViewModel(item: "user_row_address_street".localized, value: address.street as AnyObject?),
                        UserRowViewModel(item: "user_row_address_city".localized, value: address.city as AnyObject?),
                        UserRowViewModel(item: "user_row_address_post_code".localized, value: address.postCode as AnyObject?),
                        UserRowViewModel(item: "user_row_address_country".localized, value: address.country as AnyObject?)
                        ]))
                }
                
                if let points = user.points {
                    self.data.append(UserData(header: UserHeaderViewModel(title: "user_header_points".localized), rows: [
                        UserRowViewModel(item: "user_row_points_received".localized, value: points.totalReceived as AnyObject?),
                        UserRowViewModel(item: "user_row_points_total".localized, value: points.total as AnyObject?),
                        UserRowViewModel(item: "user_row_points_app".localized, value: points.totalPointsReceivedInCurrentApp as AnyObject?),
                        UserRowViewModel(item: "user_row_points_available".localized, value: points.availableBalance as AnyObject?),
                        UserRowViewModel(item: "user_row_points_pending".localized, value: points.pending as AnyObject?)
                        ]))
                }
                
                if let permissions = user.applicationPermissions {
                    self.data.append(UserData(header: UserHeaderViewModel(title: "user_header_perm".localized), rows: [
                        UserRowViewModel(item: "user_row_perm_address".localized, value: permissions.accessAddress as AnyObject?),
                        UserRowViewModel(item: "user_row_perm_phone".localized, value: permissions.accessPhoneNumber as AnyObject?),
                        UserRowViewModel(item: "user_row_perm_first_name".localized, value: permissions.accessFirstName as AnyObject?),
                        UserRowViewModel(item: "user_row_perm_last_name".localized, value: permissions.accessLastName as AnyObject?),
                        UserRowViewModel(item: "user_row_perm_email".localized, value: permissions.accessEmail as AnyObject?),
                        UserRowViewModel(item: "user_row_perm_street".localized, value: permissions.accessStreetAddress as AnyObject?),
                        UserRowViewModel(item: "user_row_perm_city".localized, value: permissions.accessCity as AnyObject?),
                        UserRowViewModel(item: "user_row_perm_post_code".localized, value: permissions.accessPostalCode as AnyObject?),
                        UserRowViewModel(item: "user_row_perm_country".localized, value: permissions.accessCountry as AnyObject?),
                        UserRowViewModel(item: "user_row_perm_notifications".localized, value: permissions.sendPushNotification as AnyObject?),
                        UserRowViewModel(item: "user_row_perm_newsletter".localized, value: permissions.sendNewsletter as AnyObject?)
                        ]))
                }
                
                success()
            } else {
                error()
            }
        }
    }
    
    // MARK: Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return data[section].header.heightForRow()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return data[section].header.representationAsRow(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].heightForRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return data[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row].representationAsRow(tableView)
    }
    
}
