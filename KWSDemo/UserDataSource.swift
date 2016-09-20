//
//  UserDataSource.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 11/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class UserDataSource: NSObject, DataSource, UITableViewDataSource, UITableViewDelegate {

    private struct UserData {
        var header: ViewModel
        var rows: [ViewModel] = []
    }

    private var data: [UserData] = []
    
    // MARK: DataSourceProtocol
    
    func update(start start: ()->Void, success: ()->Void, error: ()->Void) -> Void {
        
        // start
        start()
        
        // load data
        KWS.sdk().getUser { (user: KWSUser!) in
            
            // perform operations on data
            if let user = user {
                
                self.data.append(UserData(header: UserHeaderViewModel(title: user.username), rows: [
                    UserRowViewModel(item: "user_row_details_first_name".localized, value: user.firstName),
                    UserRowViewModel(item: "user_row_details_last_name".localized, value: user.lastName),
                    UserRowViewModel(item: "user_row_details_birth_date".localized, value: user.dateOfBirth),
                    UserRowViewModel(item: "user_row_details_email".localized, value: user.email),
                    UserRowViewModel(item: "user_row_details_phone".localized, value: user.phoneNumber),
                    UserRowViewModel(item: "user_row_details_gender".localized, value: user.gender),
                    UserRowViewModel(item: "user_row_details_language".localized, value: user.language)
                ]))
                
                if let address = user.address {
                    self.data.append(UserData(header: UserHeaderViewModel(title: "user_header_address".localized), rows: [
                        UserRowViewModel(item: "user_row_address_street".localized, value: address.street),
                        UserRowViewModel(item: "user_row_address_city".localized, value: address.city),
                        UserRowViewModel(item: "user_row_address_post_code".localized, value: address.postCode),
                        UserRowViewModel(item: "user_row_address_country".localized, value: address.country)
                        ]))
                }
                
                if let points = user.points {
                    self.data.append(UserData(header: UserHeaderViewModel(title: "user_header_points".localized), rows: [
                        UserRowViewModel(item: "user_row_points_received".localized, value: points.totalReceived),
                        UserRowViewModel(item: "user_row_points_total".localized, value: points.total),
                        UserRowViewModel(item: "user_row_points_app".localized, value: points.totalPointsReceivedInCurrentApp),
                        UserRowViewModel(item: "user_row_points_available".localized, value: points.availableBalance),
                        UserRowViewModel(item: "user_row_points_pending".localized, value: points.pending)
                        ]))
                }
                
                if let permissions = user.applicationPermissions {
                    self.data.append(UserData(header: UserHeaderViewModel(title: "user_header_perm".localized), rows: [
                        UserRowViewModel(item: "user_row_perm_address".localized, value: permissions.accessAddress),
                        UserRowViewModel(item: "user_row_perm_phone".localized, value: permissions.accessPhoneNumber),
                        UserRowViewModel(item: "user_row_perm_first_name".localized, value: permissions.accessFirstName),
                        UserRowViewModel(item: "user_row_perm_last_name".localized, value: permissions.accessLastName),
                        UserRowViewModel(item: "user_row_perm_email".localized, value: permissions.accessEmail),
                        UserRowViewModel(item: "user_row_perm_street".localized, value: permissions.accessStreetAddress),
                        UserRowViewModel(item: "user_row_perm_city".localized, value: permissions.accessCity),
                        UserRowViewModel(item: "user_row_perm_post_code".localized, value: permissions.accessPostalCode),
                        UserRowViewModel(item: "user_row_perm_country".localized, value: permissions.accessCountry),
                        UserRowViewModel(item: "user_row_perm_notifications".localized, value: permissions.sendPushNotification),
                        UserRowViewModel(item: "user_row_perm_newsletter".localized, value: permissions.sendNewsletter)
                        ]))
                }
                
                success()
            } else {
                error()
            }
        }
    }
    
    // MARK: Table
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return data[section].header.heightForRow()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return data[section].header.representationAsRow(tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].rows.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return data[indexPath.section].rows[indexPath.row].heightForRow()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return data[indexPath.section].rows[indexPath.row].representationAsRow(tableView)
    }
    
}
