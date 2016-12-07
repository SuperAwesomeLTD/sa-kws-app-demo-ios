//
//  FeaturesViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class FeatureViewController: UIViewController {

    // constants
//    fileprivate let DOCSURL: String = "https://developers.superawesome.tv/extdocs/sa-kws-android-sdk/html/index.html"
//    fileprivate let KWS_API: String = "https://kwsapi.demo.superawesome.tv/v1/"
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
//    fileprivate var dataSource: FeatureDataSource!
//    fileprivate var center: NotificationCenter!
//    fileprivate var onStart: Bool = true
    
    ////////////////////////////////////////////////////////////////////////////
    // MARK: View Controller Setup
    ////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
//        center = NotificationCenter.default
        
//        // set observer
//        center.addObserver(self, selector: #selector(didObserveAuth), name: NSNotification.Name(rawValue: Notifications.AUTH.rawValue), object: nil)
//        center.addObserver(self, selector: #selector(didObservePerm), name: NSNotification.Name(rawValue: Notifications.PERM.rawValue), object: nil)
//        center.addObserver(self, selector: #selector(didObserveAdd20Points), name: NSNotification.Name(rawValue: Notifications.ADD_20.rawValue), object: nil)
//        center.addObserver(self, selector: #selector(didObserveSub10Points), name: NSNotification.Name(rawValue: Notifications.SUB_10.rawValue), object: nil)
//        center.addObserver(self, selector: #selector(didObserveSeeLeader), name: NSNotification.Name(rawValue: Notifications.LEADER.rawValue), object: nil)
//        center.addObserver(self, selector: #selector(didObserveSubscribe), name: NSNotification.Name(rawValue: Notifications.SUBSCRIBE.rawValue), object: nil)
//        center.addObserver(self, selector: #selector(didObserveDocs), name: NSNotification.Name(rawValue: Notifications.DOCS.rawValue), object: nil)
//        center.addObserver(self, selector: #selector(didObserveGetScore), name: NSNotification.Name(rawValue: Notifications.SCORE.rawValue), object: nil)
//        center.addObserver(self, selector: #selector(didObserveInviteFriend), name: NSNotification.Name(rawValue: Notifications.INVITE.rawValue), object: nil)
//        center.addObserver(self, selector: #selector(didObserveSeeAppData), name: NSNotification.Name(rawValue: Notifications.APPDATA.rawValue), object: nil)
//        KWSSingleton.sharedInstance.addObserver(self, forKeyPath: "isRegistered", options: NSKeyValueObservingOptions.new, context: nil)
//        KWSSingleton.sharedInstance.addObserver(self, forKeyPath: "isLogged", options: NSKeyValueObservingOptions.new, context: nil)
//        KWSSingleton.sharedInstance.start()
//        
//        dataSource = FeatureDataSource()
//        tableView.dataSource = dataSource
//        tableView.delegate = dataSource
//        dataSource.update(start: {
//            // do nothing
//            }, success: { 
//                // do nothing
//            }, error: {
//                // do nothing
//        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
//    ////////////////////////////////////////////////////////////////////////////
//    // MARK: Observer functions
//    ////////////////////////////////////////////////////////////////////////////
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        
//        
//        if let change = change, let keyPath = keyPath {
//            if keyPath == "isRegistered" {
//                self.tableView.reloadData()
//            }
//            else if keyPath == "isLogged" {
//                if let logedInStatus = change[.newKey] as? Bool {
//                    if logedInStatus {
//                        let model = KWSSingleton.sharedInstance.getUser()
//                        if let model = model {
//                            KWS.sdk().setup(withOAuthToken: model.token, kwsApiUrl: KWS_API)
//                        }
//                        if onStart {
//                            onStart = false
//                            KWSSingleton.sharedInstance.markUserAsUnregistered()
//                            KWS.sdk().isRegistered({ (registerd: Bool) in
//                                if registerd {
//                                    KWSSingleton.sharedInstance.markUserAsRegistered()
//                                    self.tableView.reloadData()
//                                }
//                            })
//                        } else {
//                            tableView.reloadData()
//                        }
//                    } else {
//                        SAActivityView.sharedManager().show()
//                        KWS.sdk().unregister { (success) in
//                            SAActivityView.sharedManager().hide()
//                            KWSSingleton.sharedInstance.markUserAsUnregistered()
//                            KWS.sdk().desetup()
//                            self.tableView.reloadData()
//                        }
//                    }
//
//                }
//            }
//        }
//    }
//    
//    func didObserveAuth () {
//        let logged = KWSSingleton.sharedInstance.isUserLogged()
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: logged ? "UserNavControllerId" : "SignUpNavControllerId")
//        present(vc, animated: true, completion: nil)
//    }
//    
//    func didObserveSubscribe () {
//        SAActivityView.sharedManager().show()
//        
//        // user *IS NOT* registered
//        if (!KWSSingleton.sharedInstance.isUserMarkedAsRegistered()) {
//            
//            // define callback
//            var callback: ((Bool, KWSErrorType)->Void)!
//            callback = { (success: Bool, error: KWSErrorType) in
//                
//                SAActivityView.sharedManager().hide()
//                
//                if (success) {
//                    self.featurePopup("feature_notif_reg_popup_success_title".localized, "feature_notif_reg_popup_success_message".localized)
//                    KWSSingleton.sharedInstance.markUserAsRegistered()
//                } else {
//                    if (error == .UserHasNoParentEmail) {
//                        
//                        KWS.sdk().submitParentEmail(popup: { (submitted: Bool) in
//                            if (submitted) {
//                                SAActivityView.sharedManager().show()
//                                KWS.sdk().register(callback)
//                            } else {
//                                self.featurePopup("feature_parent_email_popup_error_title".localized, "feature_parent_email_popup_error_message".localized)
//                            }
//                        })
//                    } else {
//                        self.featurePopup("feature_notif_reg_popup_error_title".localized, "feature_notif_reg_popup_error_message".localized)
//                    }
//                }
//            }
//            
//            // start procedure
//            KWS.sdk().register(callback)
//        }
//        // user *IS* registered
//        else {
//            KWS.sdk().unregister({ (success) in
//                SAActivityView.sharedManager().hide()
//                if (success) {
//                    self.featurePopup("feature_notif_unreg_popup_success_title".localized, "feature_notif_unreg_popup_success_message".localized)
//                    KWSSingleton.sharedInstance.markUserAsUnregistered()
//                } else {
//                    self.featurePopup("feature_notif_unreg_popup_error_title".localized, "feature_notif_unreg_popup_error_message".localized)
//                }
//            })
//        }
//    }
//    
//    func didObservePerm () {
//        // Create the action sheet
//        let myActionSheet = UIAlertController(title: "feature_perm_alert_title".localized,
//                                              message: "feature_perm_alert_message".localized,
//                                              preferredStyle: UIAlertControllerStyle.actionSheet)
//        
//        // get the titles & associated types
//        let permissions = [
//            [ "name":"Email", "type": KWSPermissionType.accessEmail.rawValue ],
//            [ "name":"Address", "type": KWSPermissionType.accessAddress.rawValue ],
//            [ "name":"First name", "type": KWSPermissionType.accessFirstName.rawValue ],
//            [ "name":"Last name", "type": KWSPermissionType.accessLastName.rawValue ],
//            [ "name":"Phone number", "type": KWSPermissionType.accessPhoneNumber.rawValue ],
//            [ "name":"Newesletter", "type": KWSPermissionType.sendNewsletter.rawValue ]
//        ]
//        
//        for i in 0 ..< permissions.count {
//            
//            if let title = permissions[i]["name"] as? String, let type = permissions[i]["type"] as? NSInteger {
//                
//                // add actions to the action sheet
//                myActionSheet.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: { (action) in
//                    // get the actual (one) requested permissions
//                    let requestedPermission = [type]
//                    
//                    // define the callback, and all it's error cases
//                    var callback: ((Bool, Bool) -> Void)!
//                    callback = { (success: Bool, requested: Bool) in
//                        if (requested) {
//                            self.featurePopup("feature_perm_popup_success_title".localized, "feature_perm_popup_success_message".localized)
//                        } else {
//                            KWS.sdk().submitParentEmail(popup: { (success: Bool) in
//                                if (success) {
//                                    KWS.sdk().requestPermission(requestedPermission as [NSNumber]!, callback)
//                                } else {
//                                    self.featurePopup("feature_parent_email_popup_error_title".localized, "feature_parent_email_popup_error_message".localized)
//                                }
//                            })
//                        }
//                    }
//                    // call this
//                    KWS.sdk().requestPermission(requestedPermission as [NSNumber]!, callback)
//                }))
//            }
//            
//        }
//        
//        // present the action sheet
//        self.present(myActionSheet, animated: true, completion: nil)
//    }
//    
//    func didObserveAdd20Points () {
//        KWS.sdk().triggerEvent("GabrielAdd20ForAwesomeApp", withPoints: 20, andDescription: "You just earned 20 points!") { (success: Bool) in
//            if (success) {
//                self.featurePopup("feature_event_add20_popup_success_title".localized, "feature_event_add20_popup_success_message".localized)
//            }
//        }
//    }
//    
//    func didObserveSub10Points () {
//        KWS.sdk().triggerEvent("GabrielSub10ForAwesomeApp", withPoints: -10, andDescription: "You jost lost 10 points!") { (success: Bool) in
//            if (success) {
//                self.featurePopup("feature_event_sub10_popup_success_title".localized, "feature_event_sub10_popup_success_message".localized)
//            }
//        }
//    }
//    
//    func didObserveGetScore () {
//        KWS.sdk().getScore { (score: KWSScore?) in
//            if let score = score {
//                let title = "feature_event_getscore_success_title".localized
//                let message = NSString(format: "feature_event_getscore_success_message".localized as NSString, score.rank, score.score) as String;
//                let button = "feature_popup_dismiss_button".localized
//                SAPopup.sharedManager().show(withTitle: title, andMessage: message, andOKTitle: button, andNOKTitle: nil, andTextField: false, andKeyboardTyle: UIKeyboardType.default, andPressed: nil)
//            }
//        }
//    }
//    
//    func didObserveSeeLeader () {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "LeaderboardNavControllerId")
//        present(vc, animated: true, completion: nil)
//    }
//    
//    func didObserveInviteFriend () {
//        let title = "feature_friend_email_popup_title".localized
//        let message = "feature_friend_email_popup_message".localized
//        let submit = "feature_friend_email_popup_submit".localized
//        let cancel = "feature_friend_email_popup_cancel".localized
//        
//        SAPopup.sharedManager().show(withTitle: title, andMessage: message, andOKTitle: submit, andNOKTitle: cancel, andTextField: true, andKeyboardTyle: UIKeyboardType.emailAddress) { (button, email) in
//            if button == 0 {
//                
//                SAActivityView.sharedManager().show()
//                
//                KWS.sdk().inviteUser(email, { (invited) in
//                    
//                    SAActivityView.sharedManager().hide()
//                    
//                    if invited {
//                        let title = "feature_friend_email_popup_success_title".localized
//                        let message = NSString(format: "feature_friend_email_popup_success_message".localized as NSString, email!) as String
//                        let button = "feature_popup_dismiss_button".localized
//                        SAPopup.sharedManager().show(withTitle: title, andMessage: message, andOKTitle: button, andNOKTitle: nil, andTextField: false, andKeyboardTyle: UIKeyboardType.default, andPressed: nil)
//                    } else {
//                        let title = "feature_friend_email_popup_error_title".localized
//                        let message = NSString(format: "feature_friend_email_popup_error_message".localized as NSString, email!) as String
//                        let button = "feature_popup_dismiss_button".localized
//                        SAPopup.sharedManager().show(withTitle: title, andMessage: message, andOKTitle: button, andNOKTitle: nil, andTextField: false, andKeyboardTyle: UIKeyboardType.default, andPressed: nil)
//                    }
//                })
//            }
//        }
//    }
//    
//    func didObserveSeeAppData () {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "GetAppDataNavControllerId")
//        present(vc, animated: true, completion: nil)
//    }
//    
//    func didObserveDocs () {
//        let url = URL(string: DOCSURL)
//        UIApplication.shared.openURL(url!)
//    }
    
    
    func featurePopup(_ title: String, _ message: String) {
        
//        SAPopup.sharedManager().show(withTitle: title,
//                                              andMessage: message,
//                                              andOKTitle: "feature_popup_dismiss_button".localized,
//                                              andNOKTitle: nil,
//                                              andTextField: false,
//                                              andKeyboardTyle: .alphabet,
//                                              andPressed: nil)
        
    }
}
