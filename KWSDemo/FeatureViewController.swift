//
//  FeaturesViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 21/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SAUtils
import KWSiOSSDKObjC

class FeatureViewController: KWSBaseController {

    // constants to setup KWS
    fileprivate let CLIENT = "sa-mobile-app-sdk-client-0"
    fileprivate let SECRET = "_apikey_5cofe4ppp9xav2t9"
    fileprivate let API = "https://kwsapi.demo.superawesome.tv/"
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    // the data source
    var dataSource: Observable<RxDataSource>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        // setup the session
        KWS.sdk().startSession(withClientId: CLIENT, andClientSecret: SECRET, andAPIUrl: API)
        
        dataSource = Observable
            .from([
                FeatureAuthViewModel (),
                FeatureNotifViewModel (),
                FeaturePermViewModel (),
                FeatureEventViewModel (),
                FeatureInviteViewModel (),
                FeatureAppDataViewModel ()
            ])
            .toArray()
            .bindTable(tableView)
            //
            // customise Login & Logout row
            .customiseRow(cellIdentifier: "FeatureAuthRowId",
                          cellType: FeatureAuthViewModel.self,
                          cellHeight: 298)
            { (model, cell) in
                
                let cell = cell as? FeatureAuthRow
                
                let isLogged = KWS.sdk().getLoggedUser() != nil
                let local = KWS.sdk().getLoggedUser()
                
                cell?.authActionButton.setTitle(
                    isLogged ?
                        "feature_cell_auth_button_1_loggedin".localized + (local?.username.uppercased())! :
                        "feature_cell_auth_button_1_loggedout".localized, for: .normal)
                
                cell?.authActionButton.rx
                    .tap
                    .flatMap({ () -> Observable <UIViewController> in
                        let lIsLogged = KWS.sdk().getLoggedUser() != nil
                        return self.rxSeque(withIdentifier: lIsLogged ? "FeaturesToUserSegue" : "FeaturesToLoginSegue")
                    })
                    .subscribe(onNext: { (destination) in
                        // do nothing
                    })
                    .addDisposableTo(self.disposeBag)
                
                cell?.authDocsButton.rx.tap.subscribe (onNext: { Void in
                    
                    self.openDocumentation()
                    
                }).addDisposableTo(self.disposeBag)
                
            }
            //
            // customise the Remote Notifications row
            .customiseRow(cellIdentifier: "FeatureNotifRowId",
                          cellType: FeatureNotifViewModel.self,
                          cellHeight: 248)
            { (model, cell) in
                
                let cell = cell as? FeatureNotifRow
                
                let isLogged = KWS.sdk().getLoggedUser() != nil
                let isRegistered = isLogged && KWS.sdk().getLoggedUser().isRegisteredForNotifications()
                
                cell?.notifEnableOrDisableButton.isEnabled = isLogged
                cell?.notifEnableOrDisableButton.setTitle(
                    isRegistered ?
                    "feature_cell_notif_button_1_disable".localized :
                    "feature_cell_notif_button_1_enable".localized, for: .normal)
                
                cell?.notifEnableOrDisableButton.rx.tap.subscribe (onNext: { Void in
                
                    // do nothing for now
                    
                }).addDisposableTo(self.disposeBag)
                
                cell?.notifDocButton.rx.tap.subscribe (onNext: { Void in
                    
                    self.openDocumentation()
                    
                }).addDisposableTo(self.disposeBag)
                
            }
            // 
            // customise the Permissions row
            .customiseRow(cellIdentifier: "FeaturePermRowId",
                          cellType: FeaturePermViewModel.self,
                          cellHeight: 248)
            { (model, cell) in
                
                let cell = cell as? FeaturePermRow
                
                let isLogged = KWS.sdk().getLoggedUser() != nil
                
                cell?.permAddPermissionsButton.isEnabled = isLogged
                
                cell?.permAddPermissionsButton.rx.tap.subscribe (onNext: { Void in
                
                    // do nothing for now
                    
                }).addDisposableTo(self.disposeBag)
                
                cell?.permSeeDocsButton.rx.tap.subscribe (onNext: { Void in
                    
                    self.openDocumentation()
                    
                }).addDisposableTo(self.disposeBag)
                
            }
            //
            // customise the Events row
            .customiseRow(cellIdentifier: "FeatureEventRowId",
                          cellType: FeatureEventViewModel.self,
                          cellHeight: 368)
            { (model, cell) in
             
                let cell = cell as? FeatureEventRow
                
                let isLogged = KWS.sdk().getLoggedUser() != nil
                
                cell?.evtAdd20PointsButton.isEnabled = isLogged
                cell?.evtSub10PointsButton.isEnabled = isLogged
                cell?.evtGetScoreButton.isEnabled = isLogged
                cell?.evtSeeLeaderboardButton.isEnabled = isLogged
                
                cell?.evtAdd20PointsButton.rx
                    .tap
                    .flatMap({ (Void) -> Observable <Bool> in
                        return RxKWS.triggerEvent(event: "GabrielAdd20ForAwesomeApp")
                    })
                    .subscribe(onNext: { (isTriggered: Bool) in
                        
                        if isTriggered {
                            
                            self.featurePopup("feature_event_add20_popup_success_title".localized,
                                              "feature_event_add20_popup_success_message".localized)
                            
                        } else {
                            // do nothing
                        }
                        
                    })
                    .addDisposableTo(self.disposeBag)
                
                cell?.evtSub10PointsButton.rx
                    .tap
                    .flatMap({ (Void) -> Observable <Bool> in
                        return RxKWS.triggerEvent(event: "GabrielSub10ForAwesomeApp")
                    })
                    .subscribe(onNext: { (isTriggered: Bool) in
                        
                        if isTriggered {
                            
                            self.featurePopup("feature_event_sub10_popup_success_title".localized,
                                              "feature_event_sub10_popup_success_message".localized)
                            
                        } else {
                            // do nothing
                        }
                        
                    })
                    .addDisposableTo(self.disposeBag)
                
                cell?.evtGetScoreButton.rx
                    .tap
                    .flatMap({ (Void) -> Observable <KWSScore?> in
                        return RxKWS.getScore()
                    })
                    .subscribe(onNext: { (score: KWSScore?) in
                        
                        if let score = score {
                            
                            let message = NSString(format: "feature_event_getscore_success_message".localized as NSString, score.rank, score.score) as String
                            
                            self.featurePopup("feature_event_getscore_success_title".localized,
                                              message)
                            
                        } else {
                            // do nothing
                        }
                        
                    })
                    .addDisposableTo(self.disposeBag)
                
                cell?.evtSeeLeaderboardButton.rx
                    .tap
                    .flatMap({ () -> Observable <UIViewController> in
                        return self.rxSeque(withIdentifier: "FeaturesToLeaderboardSegue")
                    })
                    .subscribe(onNext: { (destination) in
                        // do nothing
                    })
                    .addDisposableTo(self.disposeBag)
                
                cell?.evtSeeDocsButton.rx.tap.subscribe (onNext: { Void in
                
                    self.openDocumentation()
                    
                }).addDisposableTo(self.disposeBag)
                
            }
            //
            // customise the Invite row
            .customiseRow(cellIdentifier: "FeatureInviteRowId",
                          cellType: FeatureInviteViewModel.self,
                          cellHeight: 248)
            { (model, cell) in
                
                let cell = cell as? FeatureInviteRow
                
                let isLogged = KWS.sdk().getLoggedUser() != nil
                
                cell?.invInviteFriendButton.isEnabled = isLogged
                
                
                cell?.invInviteFriendButton.rx.tap.subscribe (onNext: { Void in
                
                    // do nothing
                    
                }).addDisposableTo(self.disposeBag)
                
                cell?.invSeeDocsButton.rx.tap.subscribe (onNext: { Void in
                
                    self.openDocumentation()
                
                }).addDisposableTo(self.disposeBag)
                
            }
            //
            // customise the App Data row
            .customiseRow(cellIdentifier: "FeatureAppDataRowId",
                          cellType: FeatureAppDataViewModel.self,
                          cellHeight: 248)
            { (model, cell) in
                
                let cell = cell as? FeatureAppDataRow
                
                let isLogged = KWS.sdk().getLoggedUser() != nil
                
                cell?.appdSeeAppDataButton.isEnabled = isLogged
                
                cell?.appdSeeAppDataButton.rx
                    .tap
                    .flatMap({ () -> Observable <UIViewController> in
                        return self.rxSeque(withIdentifier: "FeaturesToAddDataSegue")
                    })
                    .subscribe(onNext: { (destination) in
                        // do nothing
                    })
                    .addDisposableTo(self.disposeBag)
                
                cell?.appdSeeDocsButton.rx.tap.subscribe (onNext: { Void in
                    
                    self.openDocumentation()
                    
                }).addDisposableTo(self.disposeBag)
            
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataSource?.update().addDisposableTo(self.disposeBag)
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
    func openDocumentation () {
        let docUrl: String = "http://doc.superawesome.tv/sa-kws-ios-sdk/latest/"
        let url = URL(string: docUrl)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    
    func featurePopup(_ title: String, _ message: String) {
        
        SAPopup.sharedManager().show(withTitle: title,
                                     andMessage: message,
                                     andOKTitle: "feature_popup_dismiss_button".localized,
                                     andNOKTitle: nil,
                                     andTextField: false,
                                     andKeyboardTyle: .alphabet,
                                     andPressed: nil)
        
    }
}
