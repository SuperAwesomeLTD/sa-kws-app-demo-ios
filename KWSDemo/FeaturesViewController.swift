//
//  FeaturesViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeaturesViewController: UIViewController, UITableViewDelegate, AuthCellProtocol, NotifCellProtocol, SignUpViewControllerProtocol, LogOutViewControllerProtocol {

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
        return indexPath.row == 0 ? 298 : 288
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

    func notifCellProtocolDidClickOnEnable() {
        if KWSSingleton.sharedInstance.appHasAuthenticatedUser() {
            
            let kwsModel = KWSSingleton.sharedInstance.getModel() as KWSModel?
            if let kwsModel = kwsModel {
                SAActivityView.sharedManager().showActivityView()
                KWS.sdk().setupWithOAuthToken(kwsModel.token, kwsApiUrl: self.KWS_API)
                
                var callback: ((Bool, KWSErrorType)->Void)!
                callback = { (success: Bool, error: KWSErrorType) in
                    
                    SAActivityView.sharedManager().hideActivityView()
                    
                    if (success) {
                        SAPopup.sharedManager().showWithTitle("Great!", andMessage: "Successfully registered for Remote Notifications!", andOKTitle: "OK!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                    } else {
                        if (error == .UserHasNoParentEmail) {
                            KWS.sdk().submitParentEmailWithPopup({ (submitted: Bool) in
                                if (submitted) {
                                    KWS.sdk().register(callback)
                                } else {
                                    
                                }
                            })
                        } else {
                            SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "An error occured trying to subscribe to Push Notifications: \(error)", andOKTitle: "Got it!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                        }
                    }
                }
                
                KWS.sdk().register(callback)
            }
        } else {
            SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "Before enabling Push Notifications you must authenticate with KWS.", andOKTitle: "Got it!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: UIKeyboardType.Alphabet, andPressed: nil)
        }
        
    }
    
    func notifCellProtocolDidClickonDisable() {
        if KWSSingleton.sharedInstance.appHasAuthenticatedUser() {
            SAActivityView.sharedManager().showActivityView()
            KWS.sdk().unregister({ (success) in
                SAActivityView.sharedManager().hideActivityView()
                if (success) {
                    SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "You have successfully un-registered for Remote Notifications in KWS!", andOKTitle: "Great", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                } else {
                    SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "There was a network error trying to un-register for Remote Notifications in KWS. Please try again!", andOKTitle: "Got it!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                }
            })
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
    // MARK: - KWSPROTOCOL -
    
//    func kwsSDKDidRegisterUserForRemoteNotifications() {
//        SAActivityView.sharedManager().hideActivityView()
//        SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "You have successfully registered for Remote Notifications in KWS!", andOKTitle: "Great", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
//    }
//    
//    func kwsSDKDidFailToRegisterUserForRemoteNotificationsWithError(errorType: KWSErrorType) {
//        
//        switch errorType {
//        case .ParentHasDisabledRemoteNotifications:
//            SAActivityView.sharedManager().hideActivityView()
//            SAPopup.sharedManager().showWithTitle("Error!", andMessage: "Parent has disabled remote notifications for this user from KWS.", andOKTitle: "Ok", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
//            break
//        case .UserHasDisabledRemoteNotifications:
//            SAActivityView.sharedManager().hideActivityView()
//            SAPopup.sharedManager().showWithTitle("Error!", andMessage: "User has disabled remote notifications on the device.", andOKTitle: "Ok", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
//            break
//        case .UserHasNoParentEmail:
//            SAActivityView.sharedManager().hideActivityView()
//            SAPopup.sharedManager().showWithTitle("Hey!",
//                                                  andMessage: "In order to enable KWS Remote Notifications you must specify a parent email",
//                                                  andOKTitle: "Submit",
//                                                  andNOKTitle: "Cancel",
//                                                  andTextField: true,
//                                                  andKeyboardTyle: UIKeyboardType.EmailAddress,
//                                                  andOKBlock: { (email: String!) in
//                SAActivityView.sharedManager().showActivityView()
//                KWS.sdk().submitParentEmail(email)
//            }, andNOKBlock: {
//               // cancel
//            })
//            break
//        case .ParentEmailInvalid:
//            SAActivityView.sharedManager().hideActivityView()
//            SAPopup.sharedManager().showWithTitle("Error!", andMessage: "The email you submitted is invalid.", andOKTitle: "Ok", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
//            break
//        case .FirebaseNotSetup:
//            SAActivityView.sharedManager().hideActivityView()
//            SAPopup.sharedManager().showWithTitle("Error!", andMessage: "The Firebase SDK is not correctly setup.", andOKTitle: "Ok", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
//            break
//        case .FirebaseCouldNotGetToken:
//            SAActivityView.sharedManager().hideActivityView()
//            SAPopup.sharedManager().showWithTitle("Error!", andMessage: "The Firebase SDK could not obtain a valid token.", andOKTitle: "Ok", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
//            break
//        case .FailedToCheckIfUserHasNotificationsEnabledInKWS:
//            SAActivityView.sharedManager().hideActivityView()
//            SAPopup.sharedManager().showWithTitle("Error!", andMessage: "Network error trying to check if user has Remote Notifications enabled in KWS.", andOKTitle: "Ok", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
//            break
//        case .FailedToRequestNotificationsPermissionInKWS:
//            SAActivityView.sharedManager().hideActivityView()
//            SAPopup.sharedManager().showWithTitle("Error!", andMessage: "Network error trying to request Remote Notifications permissions from KWS.", andOKTitle: "Ok", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
//            break
//        case .FailedToSubmitParentEmail:
//            SAActivityView.sharedManager().hideActivityView()
//            SAPopup.sharedManager().showWithTitle("Error!", andMessage: "Network error trying to submit parent email to KWS.", andOKTitle: "Ok", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
//            break
//        case .FailedToSubscribeTokenToKWS:
//            SAActivityView.sharedManager().hideActivityView()
//            SAPopup.sharedManager().showWithTitle("Error!", andMessage: "Network error trying to subscribe Firebase token to KWS.", andOKTitle: "Ok", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
//            break
////        case .FailedToUbsubscribeTokenToKWS:
////            SAActivityView.sharedManager().hideActivityView()
////            SAPopup.sharedManager().showWithTitle("Error!", andMessage: "Network error trying to ubsubscribe token Firebase from KWS.", andOKTitle: "Ok", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andOKBlock: nil, andNOKBlock: nil)
////            break
//        }
//    }
    
//    // MARK: KWSCheckProtocol
//    
//    func kwsSDKUserIsRegistered() {
//        
//    }
//    
//    func kwsSDKUserIsNotRegistered() {
//        
//    }
//    
//    func kwsSDKDidFailToCheckIfUserIsRegistered() {
//        
//    }
    
    // <Custom>
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
}
