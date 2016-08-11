//
//  LogOutViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 27/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

// protocol
protocol UserViewControllerProtocol {
    func userViewControllerDidManageToLogOutUser()
}

// vc
class UserViewController: UIViewController,
    KWSPopupNavigationBarProtocol,
    UITableViewDelegate,
    UITableViewDataSource {
    
    // delegate
    var delegate: UserViewControllerProtocol?
    var data: [UserDetailsModel] = []
    
    // vars
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userDetailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
        
        // make button red
        logoutButton.redButton()
        
        // load data
        SAActivityView.sharedManager().showActivityView()
        KWS.sdk().getUser { (user: KWSUser!) in
            SAActivityView.sharedManager().hideActivityView()
            
            if let user = user {
                
                // create data
                self.data.append(UserDetailsModel.Header("Details"))
                self.data.append(UserDetailsModel.Item("ID", "\(user._id)"))
                self.data.append(UserDetailsModel.Item("Username", user.username))
                self.data.append(UserDetailsModel.Item("First name", user.firstName))
                self.data.append(UserDetailsModel.Item("Last name", user.lastName))
                self.data.append(UserDetailsModel.Item("Birth date", user.dateOfBirth))
                self.data.append(UserDetailsModel.Item("Gender", user.gender))
                self.data.append(UserDetailsModel.Item("Phone", user.phoneNumber))
                self.data.append(UserDetailsModel.Item("Language", user.language))
                self.data.append(UserDetailsModel.Item("Email", user.email))
                
                if let address = user.address {
                    self.data.append(UserDetailsModel.Header("Address"))
                    self.data.append(UserDetailsModel.Item("Street", address.street))
                    self.data.append(UserDetailsModel.Item("City", address.city))
                    self.data.append(UserDetailsModel.Item("Post code", address.postCode))
                    self.data.append(UserDetailsModel.Item("Country", address.country))
                }
                
                if let points = user.points {
                    self.data.append(UserDetailsModel.Header("Points"))
                    self.data.append(UserDetailsModel.Item("Received", points.totalReceived))
                    self.data.append(UserDetailsModel.Item("Total", points.total))
                    self.data.append(UserDetailsModel.Item("In this app", points.totalPointsReceivedInCurrentApp))
                    self.data.append(UserDetailsModel.Item("Available", points.availableBalance))
                    self.data.append(UserDetailsModel.Item("Pending", points.pending))
                }
                
                if let permissions = user.applicationPermissions {
                    self.data.append(UserDetailsModel.Header("Permissions"))
                    self.data.append(UserDetailsModel.Item("Address", permissions.accessAddress))
                    self.data.append(UserDetailsModel.Item("Phone number", permissions.accessPhoneNumber))
                    self.data.append(UserDetailsModel.Item("First name", permissions.accessFirstName))
                    self.data.append(UserDetailsModel.Item("Last name", permissions.accessLastName))
                    self.data.append(UserDetailsModel.Item("Email", permissions.accessEmail))
                    self.data.append(UserDetailsModel.Item("Street address", permissions.accessStreetAddress))
                    self.data.append(UserDetailsModel.Item("City", permissions.accessCity))
                    self.data.append(UserDetailsModel.Item("Postal code", permissions.accessPostalCode))
                    self.data.append(UserDetailsModel.Item("Country", permissions.accessCountry))
                    self.data.append(UserDetailsModel.Item("Notifications", permissions.sendPushNotification))
                    self.data.append(UserDetailsModel.Item("Newsletter", permissions.sendNewsletter))
                }
                
                // reload data
                self.userDetailsTableView.reloadData()
            } else {
                SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "Could not load user data. Try again!", andOKTitle: "Got it!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Default, andPressed: nil)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .Black
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDelegate 
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item: UserDetailsModel = data[indexPath.row]
        
        if (item.type == .HEADER) {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserHeaderTableViewCellId", forIndexPath: indexPath) as! UserHeaderTableViewCell
            cell.headerTitle.text = item.headerText!
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserItemTableViewCellId", forIndexPath: indexPath) as! UserItemTableViewCell
            cell.titleLabel.text = item.itemTitle
            if let value = item.itemValue {
                cell.valueLabel.text = "\(value)"
                cell.valueLabel.textColor = UIColor.blackColor()
            } else {
                cell.valueLabel.text = "undefined"
                cell.valueLabel.textColor = UIColor.lightGrayColor()
            }
            return cell
        }
    }
    
    // MARK: KWSPopupNavigationBarProtocol
    
    func kwsPopupNavGetTitle() -> String {
        return "User details"
    }
    
    func kwsPopupNavDidPressOnClose() {
        dismissViewControllerAnimated(true) {
            // flush
        }
    }
    
    // MARK: Actions
    
    @IBAction func logoutAction(sender: AnyObject) {
        KWSSingleton.sharedInstance.setModel(nil)
        dismissViewControllerAnimated(true) { 
            self.delegate?.userViewControllerDidManageToLogOutUser()
        }
    }
}
