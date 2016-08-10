//
//  FeaturesViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeaturesViewController: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    AuthCellProtocol,
    NotifCellProtocol,
    PermCellProtocol,
    SignUpViewControllerProtocol,
    UserViewControllerProtocol {

    // constants
    private let DOCSURL: String = "https://developers.superawesome.tv/extdocs/sa-kws-android-sdk/html/index.html"
    private let KWS_API: String = "https://kwsapi.demo.superawesome.tv/v1/"
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // the local model
    private var local: KWSModel?
    private var isRegistered: Bool = false
    
    ////////////////////////////////////////////////////////////////////////////
    // MARK: View Controller Setup
    ////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        tableView.registerNib(UINib(nibName: "AuthTableViewCell", bundle: nil), forCellReuseIdentifier: "AuthTableViewCellId")
        tableView.registerNib(UINib(nibName: "NotifTableViewCell", bundle: nil), forCellReuseIdentifier: "NotifTableViewCellId")
        tableView.registerNib(UINib(nibName: "PermTableViewCell", bundle: nil), forCellReuseIdentifier: "PermTableViewCellId")
        updateStatus()
        
        // do this just once
        if local != nil {
            KWS.sdk().isRegistered({ (registerd: Bool) in
                self.isRegistered = registerd
                self.tableView.reloadData()
            })
        } else {
            isRegistered = false
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // MARK: Table setup
    ////////////////////////////////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 298 : 248
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("AuthTableViewCellId", forIndexPath: indexPath) as! AuthTableViewCell
            cell.selectionStyle = .None
            cell.delegate = self
            
            // get data for User
            if let local = local, let username = local.username {
                cell.authActionButton.setTitle("Loged in as \(username)".uppercaseString, forState: .Normal)
            } else {
                cell.authActionButton.setTitle("Authenticate user".uppercaseString, forState: .Normal)
            }
            
            return cell
        } else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("NotifTableViewCellId", forIndexPath: indexPath) as! NotifTableViewCell
            cell.selectionStyle = .None
            cell.delegate = self
            cell.notifEnableOrDisableButton.enabled = local != nil
            if (isRegistered) {
                cell.notifEnableOrDisableButton.setTitle("DISABLE PUSH NOTIFICATIONS", forState: .Normal)
            } else {
                cell.notifEnableOrDisableButton.setTitle("ENABLE PUSH NOTIFICATIONS", forState: .Normal)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("PermTableViewCellId", forIndexPath: indexPath) as! PermTableViewCell
            cell.selectionStyle = .None
            cell.delegate = self
            cell.permAddPermissionsButton.enabled = local != nil
            return cell
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // MARK: Cells Button Actions
    ////////////////////////////////////////////////////////////////////////////
    
    func authCellProtocolDidClickOnAction() {

        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        if local != nil {
            let vc = sb.instantiateViewControllerWithIdentifier("LogOutNavControllerId")
            presentViewController(vc, animated: true) {
                if let vc = vc as? UINavigationController, let vc1 = vc.viewControllers.first as? UserViewController {
                    vc1.delegate = self
                }
            }
            
        } else {
            let vc = sb.instantiateViewControllerWithIdentifier("SignUpNavControllerId")
            presentViewController(vc, animated: true) {
                if let vc = vc as? UINavigationController, let vc1 = vc.viewControllers.first as? SignUpViewController {
                    vc1.delegate = self
                }
            }
        }
    }
    
    func authCellprotocolDidClickOnDocs() {
        let url = NSURL(string: DOCSURL)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func notifCellProtocolDidClickOnEnableOrDisable() {
        
        SAActivityView.sharedManager().showActivityView()
        
        // user *IS* registered
        if (!isRegistered) {
            
            // define callback
            var callback: ((Bool, KWSErrorType)->Void)!
            callback = { (success: Bool, error: KWSErrorType) in
                
                SAActivityView.sharedManager().hideActivityView()
                
                if (success) {
                    SAPopup.sharedManager().showWithTitle("Great!", andMessage: "Successfully registered for Remote Notifications!", andOKTitle: "OK!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                    self.isRegistered = true
                    self.updateStatus()
                } else {
                    if (error == .UserHasNoParentEmail) {
                        KWS.sdk().submitParentEmailWithPopup({ (submitted: Bool) in
                            if (submitted) {
                                KWS.sdk().register(callback)
                            } else {
                                SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "An error occured trying to submit parent email. Will not continue.", andOKTitle: "Got it!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                            }
                        })
                    } else {
                        SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "An error occured trying to subscribe to Push Notifications: \(error)", andOKTitle: "Got it!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                    }
                }
            }
            
            // start procedure
            KWS.sdk().register(callback)
        }
        // user *IS NOT* registered
        else {
            KWS.sdk().unregister({ (success) in
                SAActivityView.sharedManager().hideActivityView()
                let message = success ? "You have successfully un-registered for Remote Notifications in KWS!" : "There was a network error trying to un-register for Remote Notifications in KWS. Please try again!"
                SAPopup.sharedManager().showWithTitle("Hey!", andMessage: message, andOKTitle: "Great", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                self.isRegistered = false
                self.updateStatus()
            })
        }
    }
    
    func notifCellprotocolDidClickOnDocs() {
        let url = NSURL(string: DOCSURL)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func permCellProtocolDidClickOnAddPermissions() {
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "KWS Permissions",
                                              message: "What information would you like permission for?",
                                              preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // get the titles & associated types
        let permissions = [
            [ "name":"Email", "type": KWSPermissionType.accessEmail.rawValue ],
            [ "name":"Address", "type": KWSPermissionType.accessAddress.rawValue ],
            [ "name":"First name", "type": KWSPermissionType.accessFirstName.rawValue ],
            [ "name":"Last name", "type": KWSPermissionType.accessLastName.rawValue ],
            [ "name":"Phone number", "type": KWSPermissionType.accessPhoneNumber.rawValue ],
            [ "name":"Newesletter", "type": KWSPermissionType.sendNewsletter.rawValue ]
        ]
        
        for i in 0 ..< permissions.count {
            
            if let title = permissions[i]["name"] as? String, type = permissions[i]["type"] as? NSInteger {
                
                // add actions to the action sheet
                myActionSheet.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.Default, handler: { (action) in
                    // get the actual (one) requested permissions
                    let requestedPermission = [type]
                    
                    // define the callback, and all it's error cases
                    var callback: ((Bool, Bool) -> Void)!
                    callback = { (success: Bool, requested: Bool) in
                        if (requested) {
                            SAPopup.sharedManager().showWithTitle("Great!", andMessage: "You've successfully asked for permission for \(title)", andOKTitle: "OK!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: UIKeyboardType.Default, andPressed: nil)
                        } else {
                            KWS.sdk().submitParentEmailWithPopup({ (success: Bool) in
                                if (success) {
                                    KWS.sdk().requestPermission(requestedPermission, callback)
                                } else {
                                    SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "An error occured trying to submit parent email. Will not continue.", andOKTitle: "Got it!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                                }
                            })
                        }
                    }
                    // call this
                    KWS.sdk().requestPermission(requestedPermission, callback)
                }))
            }
            
        }
        
        // present the action sheet
        self.presentViewController(myActionSheet, animated: true, completion: nil)
    }
    
    func permCellprotocolDidClickOnDocs() {
        let url = NSURL(string: DOCSURL)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // MARK: Login In or Log Out action
    ////////////////////////////////////////////////////////////////////////////
    
    func signupViewControllerDidManageToSignUpUser() {
        updateStatus()
    }
    
    func userViewControllerDidManageToLogOutUser() {
        // also unregister
        SAActivityView.sharedManager().showActivityView()
        KWS.sdk().unregister { (success) in
            SAActivityView.sharedManager().hideActivityView()
            self.isRegistered = false
            self.updateStatus()
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // MARK: Aux functions
    ////////////////////////////////////////////////////////////////////////////
    
    private func updateStatus () {
        // logged-in status
        local = KWSSingleton.sharedInstance.getModel()
        if let local = local {
            KWS.sdk().setupWithOAuthToken(local.token, kwsApiUrl: KWS_API)
        }
        // logged-out status
        else {
            KWS.sdk().desetup()
        }
        // reload
        tableView.reloadData()
    }
}
