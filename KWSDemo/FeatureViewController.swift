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
        setNeedsStatusBarAppearanceUpdate()
        
        // setup the session
        KWS.sdk().startSession(withClientId: CLIENT, andClientSecret: SECRET, andAPIUrl: API)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
                
                // update
                self.dataSource?.update(features)
                
            })
            .addDisposableTo(disposeBag)
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
