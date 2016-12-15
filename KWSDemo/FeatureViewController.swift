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
                    .customiseRow(cellIdentifier: "FeatureAuthRowId", cellType: FeatureAuthViewModel.self) { (model, cell) in
                        
                        let cell = cell as? FeatureAuthRow
                        
                        let isLogged = KWS.sdk().getLoggedUser() != nil
                        let local = KWS.sdk().getLoggedUser()
                        
                        cell?.authActionButton.setTitle(
                            isLogged ?
                                "page_features_row_auth_button_login_logged".localized + (local?.username.uppercased())! :
                                "page_features_row_auth_button_login_not_logged".localized, for: .normal)
                        
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
                    .customiseRow(cellIdentifier: "FeatureNotifRowId", cellType: FeatureNotifViewModel.self) { (model, cell) in
                        
                        let cell = cell as? FeatureNotifRow
                        
                        let isLogged = KWS.sdk().getLoggedUser() != nil
                        let isRegistered = isLogged && KWS.sdk().getLoggedUser().isRegisteredForNotifications()
                        
                        cell?.notifEnableOrDisableButton.isEnabled = isLogged
                        cell?.notifEnableOrDisableButton.setTitle(
                            isRegistered ?
                                "page_features_row_notif_button_disable".localized :
                                "page_features_row_notif_button_enable".localized, for: .normal)
                        
                        cell?.notifEnableOrDisableButton.onAction {
                            
                            let lIsRegistered = KWS.sdk().getLoggedUser() != nil && KWS.sdk().getLoggedUser().isRegisteredForNotifications()
                            
                            if lIsRegistered {
                                
                                RxKWS.unregisterForNotifications()
                                    .subscribe(onNext: { (isUnregistered: Bool) in
                                        
                                        if isUnregistered {
                                            
                                            self.featurePopup("page_features_row_notif_popup_unreg_success_title".localized,
                                                              "page_features_row_notif_popup_unreg_success_message".localized)
                                            
                                        } else {
                                            
                                            self.featurePopup("page_features_row_notif_popup_unreg_error_network_title".localized,
                                                              "page_features_row_notif_popup_unreg_error_network_message".localized)
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
                                            self.featurePopup("page_features_row_notif_popup_reg_success_title".localized,
                                                              "page_features_row_notif_popup_reg_success_message".localized)
                                            break
                                            
                                        case .parentDisabledNotifications:
                                            self.featurePopup("page_features_row_notif_popup_reg_error_disable_parent_title".localized,
                                                              "page_features_row_notif_popup_reg_error_disable_parent_message".localized)
                                            break
                                            
                                        case .userDisabledNotifications:
                                            self.featurePopup("page_features_row_notif_popup_reg_error_disable_user_title".localized,
                                                              "page_features_row_notif_popup_reg_error_disable_user_message".localized)
                                            break
                                            
                                        case .noParentEmail:
                                            self.featurePopup("page_features_row_notif_popup_reg_error_no_email_title".localized,
                                                              "page_features_row_notif_popup_reg_error_no_email_message".localized)
                                            break
                                            
                                        case .firebaseNotSetup:
                                            self.featurePopup("page_features_row_notif_popup_reg_error_firebase_not_setup_title".localized,
                                                              "page_features_row_notif_popup_reg_error_firebase_not_setup_message".localized)
                                            break
                                            
                                        case .firebaseCouldNotGetToken:
                                            self.featurePopup("page_features_row_notif_popup_reg_error_firebase_nil_token_title".localized,
                                                              "page_features_row_notif_popup_reg_error_firebase_nil_token_message".localized)
                                            break
                                            
                                        case .networkError:
                                            self.featurePopup("page_features_row_notif_popup_reg_error_network_title".localized,
                                                              "page_features_row_notif_popup_reg_error_network_message".localized)
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
                    .customiseRow(cellIdentifier: "FeaturePermRowId", cellType: FeaturePermViewModel.self) { (model, cell) in
                        
                        let cell = cell as? FeaturePermRow
                        
                        let isLogged = KWS.sdk().getLoggedUser() != nil
                        
                        cell?.permAddPermissionsButton.isEnabled = isLogged
                        
                        cell?.permAddPermissionsButton.onAction {
                            
                            let myActionSheet = UIAlertController(title: "page_features_row_perm_popup_perm_title".localized,
                                                                  message: "page_features_row_perm_popup_perm_message".localized,
                                                                  preferredStyle: .actionSheet)
                            
                            let permissions = [
                                ["name":"page_features_row_perm_popup_perm_option_email".localized,
                                 "type":KWSPermissionType.accessEmail.rawValue],
                                ["name":"page_features_row_perm_popup_perm_option_address".localized,
                                 "type":KWSPermissionType.accessAddress.rawValue],
                                ["name":"page_features_row_perm_popup_perm_option_first_name".localized,
                                 "type":KWSPermissionType.accessFirstName.rawValue],
                                ["name":"page_features_row_perm_popup_perm_option_last_name".localized,
                                 "type":KWSPermissionType.accessLastName.rawValue],
                                ["name":"page_features_row_perm_popup_perm_option_newsletter".localized,
                                 "type":KWSPermissionType.sendNewsletter.rawValue],
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
                                                        self.featurePopup("page_features_row_perm_popup_success_title".localized,
                                                                          "page_features_row_perm_popup_success_message".localized)
                                                    break
                                                    case .networkError:
                                                        self.featurePopup("page_features_row_perm_popup_error_network_title".localized,
                                                                          "page_features_row_perm_popup_error_network_message".localized)
                                                    break
                                                    case .noParentEmail:
                                                        self.featurePopup("page_features_row_perm_popup_error_no_email_title".localized,
                                                                          "page_features_row_perm_popup_error_no_email_message".localized)
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
                    .customiseRow(cellIdentifier: "FeatureEventRowId", cellType: FeatureEventViewModel.self) { (model, cell) in
                        
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
                                        self.featurePopup("page_features_row_events_popup_success_20pcts_title".localized,
                                                          "page_features_row_events_popup_success_20pcts_message".localized)
                                        
                                    } else {
                                        self.featurePopup("page_features_row_events_popup_error_network_title".localized,
                                                          "page_features_row_events_popup_error_network_message".localized)
                                    }
                                    
                                })
                                .addDisposableTo(self.disposeBag)
                        }
                        
                        cell?.evtSub10PointsButton.onAction {
                            RxKWS.triggerEvent(event: "GabrielSub10ForAwesomeApp")
                                .subscribe(onNext: { (isTriggered) in
                                
                                    if isTriggered {
                                        self.featurePopup("page_features_row_events_popup_success_10pcts_title".localized,
                                                          "page_features_row_events_popup_success_10pcts_message".localized)
                                        
                                    } else {
                                        self.featurePopup("page_features_row_events_popup_error_network_title".localized,
                                                          "page_features_row_events_popup_error_network_message".localized)
                                    }
                                    
                                })
                                .addDisposableTo(self.disposeBag)
                        }
                        
                        cell?.evtGetScoreButton.onAction {
                            
                            RxKWS.getScore()
                                .subscribe(onNext: { (score: KWSScore?) in
                                    
                                    if let score = score {
                                        
                                        let message = NSString(format: "page_features_row_events_popup_success_score_message".localized as NSString, score.rank, score.score) as String
                                        
                                        self.featurePopup("page_features_row_events_popup_success_score_title".localized,
                                                          message)
                                        
                                    } else {
                                        self.featurePopup("page_features_row_events_popup_error_network_title".localized,
                                                          "page_features_row_events_popup_error_network_message".localized)
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
                    .customiseRow(cellIdentifier: "FeatureInviteRowId", cellType: FeatureInviteViewModel.self) { (model, cell) in
                        
                        let cell = cell as? FeatureInviteRow
                        
                        let isLogged = KWS.sdk().getLoggedUser() != nil
                        
                        cell?.invInviteFriendButton.isEnabled = isLogged
                        
                        cell?.invInviteFriendButton.onAction {
                            
                            SAPopup.sharedManager().show(withTitle: "page_features_row_invite_popup_email_title".localized,
                                                         andMessage: "page_features_row_invite_popup_email_message".localized,
                                                         andOKTitle: "page_features_row_invite_popup_email_button_ok".localized,
                                                         andNOKTitle: "page_features_row_invite_popup_email_button_cancel".localized,
                                                         andTextField: true,
                                                         andKeyboardTyle: UIKeyboardType.emailAddress)
                            { (button: Int32, email: String?) in
                                
                                if let email = email, button == 0 {
                                    
                                    RxKWS.inviteFriend(email: email)
                                        .subscribe(onNext: { (invited: Bool) in
                                            
                                            if invited {
                                                self.featurePopup("page_features_row_invite_popup_success_title".localized,
                                                                  "page_features_row_invite_popup_success_message".localized)
                                                
                                            } else {
                                                self.featurePopup("page_features_row_invite_popup_error_network_title".localized,
                                                                  "page_features_row_invite_popup_error_network_message".localized)                                            }
                                            
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
                    .customiseRow(cellIdentifier: "FeatureAppDataRowId", cellType: FeatureAppDataViewModel.self) { (model, cell) in
                        
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
        self.navigationController?.navigationBar.topItem?.title = "page_features_title".localized
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
                                     andOKTitle: "page_features_row_popup_button_ok_generic".localized,
                                     andNOKTitle: nil,
                                     andTextField: false,
                                     andKeyboardTyle: .alphabet,
                                     andPressed: nil)
        
    }
}
