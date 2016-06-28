//
//  FeaturesViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeaturesViewController: UIViewController, UITableViewDelegate, AuthCellProtocol, NotifCellProtocol, SignUpViewControllerProtocol, LogOutViewControllerProtocol, KWSProtocol {

    // table view
    @IBOutlet weak var tableView: UITableView!
    
    // constants
    private let AUTHURL: String = "https://developers.superawesome.tv/extdocs/sa-kws-android-sdk/html/index.html"
    private let NOTIFURL: String = "https://developers.superawesome.tv/extdocs/sa-kws-android-sdk/html/index.html"
    private let KWS_API: String = "https://kwsapi.demo.superawesome.tv/v1/"
    
    // data source
    var dataSource: FeaturesDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        // register nibs
        tableView.registerNib(UINib(nibName: "AuthTableViewCell", bundle: nil), forCellReuseIdentifier: "AuthTableViewCellId")
        tableView.registerNib(UINib(nibName: "NotifTableViewCell", bundle: nil), forCellReuseIdentifier: "NotifTableViewCellId")
        
        // setup data source
        dataSource = FeaturesDataSource()
        if let dataSource = dataSource {
            tableView.dataSource = dataSource
            dataSource.authDelegate = self
            dataSource.notifDelegate = self
            tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // <UITableViewDelegate>
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 298 : 248
    }
    
    // <AuthCellProtocol>
    
    func authCellProtocolDidClickOnAction() {

        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        if KWSSingleton.sharedInstance.appHasAuthenticatedUser() {
            let vc = sb.instantiateViewControllerWithIdentifier("LogOutNavControllerId")
            presentViewController(vc, animated: true) {
                if let vc = vc as? UINavigationController, let vc1 = vc.viewControllers.first as? LogOutViewController {
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
        let url = NSURL(string: AUTHURL)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    // <NotifCellProtocol>

    func notifCellProtocolDidClickOnAction() {
        if KWSSingleton.sharedInstance.appHasAuthenticatedUser() {
            
            let kwsModel = KWSSingleton.sharedInstance.getModel() as KWSModel?
            if let kwsModel = kwsModel {
                let alert = UIAlertController(title: "Hey!", message: "Do you want to enable Push Notifications for this user?", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
                    KWSActivityView.sharedInstance.showActivityView()
                    KWS.sdk().setupWithOAuthToken(kwsModel.token, kwsApiUrl: self.KWS_API, delegate: self)
                    KWS.sdk().checkIfNotificationsAreAllowed()
                }
                let CancelAction = UIAlertAction(title: "No", style: .Default) { (action) in
                    // do nothing
                }
                alert.addAction(OKAction)
                alert.addAction(CancelAction)
                presentViewController(alert, animated: true) {}
            }
        } else {
            KWSSimpleAlert.sharedInstance.show(self, title: "Hey!", message: "Before enabling Push Notifications you must authenticate with KWS.", button: "Got it!")
        }
    }
    
    func notifCellprotocolDidClickOnDocs() {
        let url = NSURL(string: NOTIFURL)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    // <SignUpViewControllerProtocol>
    
    func signupViewControllerDidManageToSignUpUser() {
        tableView.reloadData()
    }
    
    // <LogOutViewControllerProtocol>
    
    func logoutViewControllerDidManageToLogOutUser() {
        tableView.reloadData()
    }
    
    // <KWSProtocol>
    
    func isAllowedToRegisterForRemoteNotifications() {
        print("isAllowedToRegisterForRemoteNotifications")
        KWS.sdk().registerForRemoteNotifications()
    }
    
    func isAlreadyRegisteredForRemoteNotifications() {
        KWSActivityView.sharedInstance.hideActivityView()
        KWSSimpleAlert.sharedInstance.show(self, title: "Great news!", message: "This user is already registered for Remote Notifications in KWS.", button: "Got it!")
    }
    
    func didRegisterForRemoteNotifications() {
        KWSActivityView.sharedInstance.hideActivityView()
        KWSSimpleAlert.sharedInstance.show(self, title: "Great news!", message: "This user has been successfully registered for Remote Notifications in KWS.", button: "Got it!")
    }
    
    func didFailBecauseKWSCouldNotFindParentEmail() {
        KWSActivityView.sharedInstance.hideActivityView()
        let alert = UIAlertController(title: "Hey!", message: "To enable Push Notifications in KWS you'll need to provide a parent's email.", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "Submit", style: .Default) { (action) in
            let textField = alert.textFields?.first
            if let textField = textField {
                KWSActivityView.sharedInstance.showActivityView()
                KWS.sdk().submitParentEmail(textField.text)
            }
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            // do nothing
        }
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            // do nothing
        }
        alert.addAction(OKAction)
        alert.addAction(CancelAction)
        presentViewController(alert, animated: true) {}
    }
    
    func didFailBecauseParentEmailIsInvalid() {
        KWSActivityView.sharedInstance.hideActivityView()
        KWSSimpleAlert.sharedInstance.show(self, title: "Ups!", message: "You must input a valid parent email!", button: "Got it!")
    }
    
    func didFailBecauseRemoteNotificationsAreDisabled() {
        KWSActivityView.sharedInstance.hideActivityView()
        KWSSimpleAlert.sharedInstance.show(self, title: "Hey!", message: "This user could not be registered because he has disabled Remote Notifications for this app.", button: "Got it!")
    }
    
    func didFailBecauseKWSDoesNotAllowRemoteNotifications() {
        KWSActivityView.sharedInstance.hideActivityView()
        KWSSimpleAlert.sharedInstance.show(self, title: "Hey!", message: "This user could not be registered for Remote Notifications because a parent in KWS has disabled this functionality.", button: "Got it!")
    }
    
    func didFailBecauseOfError() {
        KWSActivityView.sharedInstance.hideActivityView()
        KWSSimpleAlert.sharedInstance.show(self, title: "Ups!", message: "An un-identified error occured, and this user could not be registered for Remote Notifications in KWS.", button: "Got it!")
    }
    
    func didFailBecauseFirebaseIsNotSetupCorrectly() {
        KWSActivityView.sharedInstance.hideActivityView()
        KWSSimpleAlert.sharedInstance.show(self, title: "Ups!", message: "It seems Firebase isn't setup correctly! Usually this means you'll have to download a GoogleService-Info.plist from https://console.firebase.google.com.", button: "Got it!")
    }
    
    // <Custom>
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
}
