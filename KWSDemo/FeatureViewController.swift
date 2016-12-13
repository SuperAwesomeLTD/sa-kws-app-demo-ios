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
    private var dataSource: RxDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the session
        KWS.sdk().startSession(withClientId: CLIENT, andClientSecret: SECRET, andAPIUrl: API)
        
        Observable
            .from([
                FeatureAuthViewModel (),
                FeatureNotifViewModel (),
                FeaturePermViewModel (),
                FeatureEventViewModel (),
                FeatureInviteViewModel (),
                FeatureAppDataViewModel ()
            ])
            .toArray()
            .subscribe(onNext: { (features: [ViewModel]) in
                
                self.dataSource = RxDataSource
                    .bindTable(self.tableView)
                    .estimateRowHeight(100)
                    //
                    // customise Login & Logout row
                    .customiseRow(cellIdentifier: "FeatureAuthRowId",
                                  cellType: FeatureAuthViewModel.self)
                    { (model, cell) in
                        
                        let cell = cell as? FeatureAuthRow
                        
                        let isLogged = KWS.sdk().getLoggedUser() != nil
                        let local = KWS.sdk().getLoggedUser()
                        
                        cell?.authActionButton.setTitle(
                            isLogged ?
                                "feature_cell_auth_button_1_loggedin".localized + (local?.username.uppercased())! :
                                "feature_cell_auth_button_1_loggedout".localized, for: .normal)
                        
                        cell?.authActionButton.onAction {
                            let lIsLogged = KWS.sdk().getLoggedUser() != nil
                            self.performSegue(withIdentifier: lIsLogged ? "FeaturesToUserSegue" : "FeaturesToLoginSegue", sender: self)
                        }
                        
                        cell?.authDocsButton.onAction {
                            self.openDocumentation()
                        }
                    }
                    //
                    // customise the Remote Notifications row
                    .customiseRow(cellIdentifier: "FeatureNotifRowId",
                                  cellType: FeatureNotifViewModel.self)
                    { (model, cell) in
                        
                        let cell = cell as? FeatureNotifRow
                        
                        let isLogged = KWS.sdk().getLoggedUser() != nil
                        let isRegistered = isLogged && KWS.sdk().getLoggedUser().isRegisteredForNotifications()
                        
                        cell?.notifEnableOrDisableButton.isEnabled = isLogged
                        cell?.notifEnableOrDisableButton.setTitle(
                            isRegistered ?
                                "feature_cell_notif_button_1_disable".localized :
                                "feature_cell_notif_button_1_enable".localized, for: .normal)
                        
                        cell?.notifEnableOrDisableButton.onAction {
                            
                            let lIsRegistered = KWS.sdk().getLoggedUser() != nil && KWS.sdk().getLoggedUser().isRegisteredForNotifications()
                            
                            if lIsRegistered {
                                
                                RxKWS.unregisterForNotifications()
                                    .subscribe(onNext: { (isUnregistered: Bool) in
                                        
                                        if isUnregistered {
                                            
                                            self.featurePopup("feature_notif_unreg_popup_success_title".localized,
                                                              "feature_notif_unreg_popup_success_message".localized)
                                            
                                        } else {
                                            
                                            self.featurePopup("feature_notif_unreg_popup_error_title".localized,
                                                              "feature_notif_unreg_popup_error_message".localized)
                                        }
                                        
                                        // update data source
                                        self.dataSource?.update()
                                        
                                    })
                                    .addDisposableTo(self.disposeBag)
                                
                            } else {
                                
                                RxKWS.registerForNotifications()
                                    .subscribe(onNext: { (status: KWSNotificationStatus) in
                                        
                                        switch status {
                                        case .success:
                                            self.featurePopup("feature_notif_reg_popup_success_title".localized,
                                                              "feature_notif_reg_popup_success_message".localized)
                                            break
                                            
                                        case .parentDisabledNotifications:
                                            break
                                            
                                        case .userDisabledNotifications:
                                            break
                                            
                                        case .noParentEmail:
                                            break
                                            
                                        case .firebaseNotSetup:
                                            break
                                            
                                        case .firebaseCouldNotGetToken:
                                            break
                                            
                                        case .networkError:
                                            self.featurePopup("feature_notif_reg_popup_error_title".localized,
                                                              "feature_notif_reg_popup_error_message".localized)
                                            break
                                        }
                                        
                                        // update data source
                                        self.dataSource?.update()
                                        
                                    })
                                    .addDisposableTo(self.disposeBag)
                                
                            }
                            
                        }
                        
                        cell?.notifDocButton.onAction {
                            self.openDocumentation()
                        }
                    }
                    //
                    // customise the Permissions row
                    .customiseRow(cellIdentifier: "FeaturePermRowId",
                                  cellType: FeaturePermViewModel.self)
                    { (model, cell) in
                        
                        let cell = cell as? FeaturePermRow
                        
                        let isLogged = KWS.sdk().getLoggedUser() != nil
                        
                        cell?.permAddPermissionsButton.isEnabled = isLogged
                        
                        cell?.permAddPermissionsButton.onAction {
                            
                            let myActionSheet = UIAlertController(title: "feature_perm_alert_title".localized,
                                                                  message: "feature_perm_alert_message".localized,
                                                                  preferredStyle: .actionSheet)
                            
                            let permissions = [
                                ["name":"Email", "type":KWSPermissionType.accessEmail.rawValue],
                                ["name":"Address", "type":KWSPermissionType.accessAddress.rawValue],
                                ["name":"First name", "type":KWSPermissionType.accessFirstName.rawValue],
                                ["name":"Last name", "type":KWSPermissionType.accessLastName.rawValue],
                                ["name":"Newesletter", "type":KWSPermissionType.sendNewsletter.rawValue],
                                
                            ]
                            
                            for i in 0 ..< permissions.count {
                                
                                if let title = permissions[i]["name"] as? String,
                                    let type = permissions[i]["type"] as? NSInteger {
                                    
                                    myActionSheet.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
                                        
                                        let requestedPermission = [type]
                                        
                                        RxKWS.addPermissions(permissions: requestedPermission as [NSNumber]!)
                                            .subscribe(onNext: { (status: KWSPermissionStatus) in
                                                
                                                switch status {
                                                    case .success:
                                                        self.featurePopup("feature_perm_popup_success_title".localized,
                                                                          "feature_perm_popup_success_message".localized)
                                                    break
                                                    case .networkError:
                                                        // do nothing
                                                    break
                                                    case .noParentEmail:
                                                        // will now never get here
                                                    break
                                                }
                                                
                                            })
                                            .addDisposableTo(self.disposeBag)
                                        
                                    }))
                                    
                                }
                                
                            }
                            
                            // present action sheet
                            self.present(myActionSheet, animated: true, completion: nil)
                        }
                        
                        cell?.permSeeDocsButton.onAction {
                            self.openDocumentation()
                        }
                    }
                    //
                    // customise the Events row
                    .customiseRow(cellIdentifier: "FeatureEventRowId",
                                  cellType: FeatureEventViewModel.self)
                    { (model, cell) in
                        
                        let cell = cell as? FeatureEventRow
                        
                        let isLogged = KWS.sdk().getLoggedUser() != nil
                        
                        cell?.evtAdd20PointsButton.isEnabled = isLogged
                        cell?.evtSub10PointsButton.isEnabled = isLogged
                        cell?.evtGetScoreButton.isEnabled = isLogged
                        cell?.evtSeeLeaderboardButton.isEnabled = isLogged
                        
                        cell?.evtAdd20PointsButton.onAction {
                            RxKWS.triggerEvent(event: "GabrielAdd20ForAwesomeApp")
                                .subscribe(onNext: { (isTriggered) in
                                
                                    if isTriggered {
                                        
                                        self.featurePopup("feature_event_add20_popup_success_title".localized,
                                                          "feature_event_add20_popup_success_message".localized)
                                        
                                    } else {
                                        // do nothing
                                    }
                                    
                                })
                                .addDisposableTo(self.disposeBag)
                        }
                        
                        cell?.evtSub10PointsButton.onAction {
                            RxKWS.triggerEvent(event: "GabrielSub10ForAwesomeApp")
                                .subscribe(onNext: { (isTriggered) in
                                
                                    if isTriggered {
                                        
                                        self.featurePopup("feature_event_sub10_popup_success_title".localized,
                                                          "feature_event_sub10_popup_success_message".localized)
                                        
                                    } else {
                                        // do nothing
                                    }
                                    
                                })
                                .addDisposableTo(self.disposeBag)
                        }
                        
                        cell?.evtGetScoreButton.onAction {
                            
                            RxKWS.getScore()
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
                            
                        }
                        
                        cell?.evtSeeLeaderboardButton.onAction {
                            self.performSegue(withIdentifier: "FeaturesToLeaderboardSegue", sender: self)
                        }
                        
                        cell?.evtSeeDocsButton.onAction {
                            self.openDocumentation()
                        }
                    }
                    //
                    // customise the Invite row
                    .customiseRow(cellIdentifier: "FeatureInviteRowId",
                                  cellType: FeatureInviteViewModel.self)
                    { (model, cell) in
                        
                        let cell = cell as? FeatureInviteRow
                        
                        let isLogged = KWS.sdk().getLoggedUser() != nil
                        
                        cell?.invInviteFriendButton.isEnabled = isLogged
                        
                        cell?.invInviteFriendButton.onAction {
                            
                            SAPopup.sharedManager().show(withTitle: "feature_friend_email_popup_title".localized,
                                                         andMessage: "feature_friend_email_popup_message".localized,
                                                         andOKTitle: "feature_friend_email_popup_submit".localized,
                                                         andNOKTitle: "feature_friend_email_popup_cancel".localized,
                                                         andTextField: true,
                                                         andKeyboardTyle: UIKeyboardType.emailAddress)
                            { (button: Int32, email: String?) in
                                
                                if let email = email, button == 0 {
                                    
                                    RxKWS.inviteFriend(email: email)
                                        .subscribe(onNext: { (invited: Bool) in
                                            
                                            if invited {
                                                
                                                self.featurePopup("feature_friend_email_popup_success_title".localized,
                                                                  "feature_friend_email_popup_success_message".localized)
                                                
                                            } else {
                                                // send some error
                                            }
                                            
                                        })
                                        .addDisposableTo(self.disposeBag)
                                    
                                }
                            }
                        }
                        
                        cell?.invSeeDocsButton.onAction {
                            self.openDocumentation()
                        }
                    }
                    //
                    // customise the App Data row
                    .customiseRow(cellIdentifier: "FeatureAppDataRowId",
                                  cellType: FeatureAppDataViewModel.self)
                    { (model, cell) in
                        
                        let cell = cell as? FeatureAppDataRow
                        
                        let isLogged = KWS.sdk().getLoggedUser() != nil
                        
                        cell?.appdSeeAppDataButton.isEnabled = isLogged
                        
                        cell?.appdSeeAppDataButton.onAction {
                            self.performSegue(withIdentifier: "FeaturesToAddDataSegue", sender: self)
                        }
                        
                        cell?.appdSeeDocsButton.onAction {
                            self.openDocumentation()
                        }
                }
                
                // update the data for the first time
                self.dataSource?.update(features)
                
            })
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataSource?.update()
        self.navigationController?.navigationBar.topItem?.title = "feature_vc_title".localized
    }

    func openDocumentation () {
        let docUrl: String = "http://doc.superawesome.tv/sa-kws-ios-sdk/latest/"
        let url = URL(string: docUrl)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
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
