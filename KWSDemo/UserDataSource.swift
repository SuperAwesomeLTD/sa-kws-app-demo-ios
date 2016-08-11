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
                
                self.data.append(UserData(header: UserHeaderViewModel(title: "Details"), rows: [
                    UserRowViewModel(item: "ID", value: user._id),
                    UserRowViewModel(item: "Username", value: user.username),
                    UserRowViewModel(item: "First name", value: user.firstName),
                    UserRowViewModel(item: "Last name", value: user.lastName),
                    UserRowViewModel(item: "Birth date", value: user.dateOfBirth),
                    UserRowViewModel(item: "Gender", value: user.gender),
                    UserRowViewModel(item: "Phone", value: user.phoneNumber),
                    UserRowViewModel(item: "Language", value: user.language),
                    UserRowViewModel(item: "Email", value: user.email)
                ]))
                
                if let address = user.address {
                    self.data.append(UserData(header: UserHeaderViewModel(title: "Address"), rows: [
                        UserRowViewModel(item: "Street", value: address.street),
                        UserRowViewModel(item: "City", value: address.city),
                        UserRowViewModel(item: "Post code", value: address.postCode),
                        UserRowViewModel(item: "Country", value: address.country)
                        ]))
                }
                
                if let points = user.points {
                    self.data.append(UserData(header: UserHeaderViewModel(title: "Points"), rows: [
                        UserRowViewModel(item: "Received", value: points.totalReceived),
                        UserRowViewModel(item: "Total", value: points.total),
                        UserRowViewModel(item: "In this app", value: points.totalPointsReceivedInCurrentApp),
                        UserRowViewModel(item: "Available", value: points.availableBalance),
                        UserRowViewModel(item: "Pending", value: points.pending)
                        ]))
                }
                
                if let permissions = user.applicationPermissions {
                    self.data.append(UserData(header: UserHeaderViewModel(title: "Permissions"), rows: [
                        UserRowViewModel(item: "Address", value: permissions.accessAddress),
                        UserRowViewModel(item: "Phone number", value: permissions.accessPhoneNumber),
                        UserRowViewModel(item: "First name", value: permissions.accessFirstName),
                        UserRowViewModel(item: "Last name", value: permissions.accessLastName),
                        UserRowViewModel(item: "Email", value: permissions.accessEmail),
                        UserRowViewModel(item: "Street address", value: permissions.accessStreetAddress),
                        UserRowViewModel(item: "City", value: permissions.accessCity),
                        UserRowViewModel(item: "Postal code", value: permissions.accessPostalCode),
                        UserRowViewModel(item: "Country", value: permissions.accessCountry),
                        UserRowViewModel(item: "Notifications", value: permissions.sendPushNotification),
                        UserRowViewModel(item: "Newsletter", value: permissions.sendNewsletter)
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
