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
    private let DOCSURL: String = "https://developers.superawesome.tv/extdocs/sa-kws-android-sdk/html/index.html"
    private let KWS_API: String = "https://kwsapi.demo.superawesome.tv/v1/"
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    private var dataSource: FeatureDataSource!
    private var center: NSNotificationCenter!
    private var onStart: Bool = true
    
    ////////////////////////////////////////////////////////////////////////////
    // MARK: View Controller Setup
    ////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        center = NSNotificationCenter.defaultCenter()
        
        // set observer
        center.addObserver(self, selector: #selector(didObserveAuth), name: Notifications.AUTH.rawValue, object: nil)
        center.addObserver(self, selector: #selector(didObservePerm), name: Notifications.PERM.rawValue, object: nil)
        center.addObserver(self, selector: #selector(didObserveAdd20Points), name: Notifications.ADD_20.rawValue, object: nil)
        center.addObserver(self, selector: #selector(didObserveSub10Points), name: Notifications.SUB_10.rawValue, object: nil)
        center.addObserver(self, selector: #selector(didObserveSeeLeader), name: Notifications.LEADER.rawValue, object: nil)
        center.addObserver(self, selector: #selector(didObserveSubscribe), name: Notifications.SUBSCRIBE.rawValue, object: nil)
        center.addObserver(self, selector: #selector(didObserveDocs), name: Notifications.DOCS.rawValue, object: nil)
        center.addObserver(self, selector: #selector(didObserveGetScore), name: Notifications.SCORE.rawValue, object: nil)
        KWSSingleton.sharedInstance.addObserver(self, forKeyPath: "isRegistered", options: NSKeyValueObservingOptions.New, context: nil)
        KWSSingleton.sharedInstance.addObserver(self, forKeyPath: "isLogged", options: NSKeyValueObservingOptions.New, context: nil)
        KWSSingleton.sharedInstance.start()
        
        dataSource = FeatureDataSource()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        dataSource.update(start: {
            // do nothing
            }, success: { 
                // do nothing
            }, error: {
                // do nothing
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // MARK: Observer functions
    ////////////////////////////////////////////////////////////////////////////
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let change = change, let keyPath = keyPath {
            if keyPath == "isRegistered" {
                self.tableView.reloadData()
            }
            else if keyPath == "isLogged" {
                if let logedInStatus = change["new"] as? Bool {
                    if logedInStatus {
                        let model = KWSSingleton.sharedInstance.getUser()
                        if let model = model {
                            KWS.sdk().setupWithOAuthToken(model.token, kwsApiUrl: KWS_API)
                        }
                        if onStart {
                            onStart = false
                            KWSSingleton.sharedInstance.markUserAsUnregistered()
                            KWS.sdk().isRegistered({ (registerd: Bool) in
                                if registerd {
                                    KWSSingleton.sharedInstance.markUserAsRegistered()
                                    self.tableView.reloadData()
                                }
                            })
                        } else {
                            tableView.reloadData()
                        }
                    } else {
                        SAActivityView.sharedManager().showActivityView()
                        KWS.sdk().unregister { (success) in
                            SAActivityView.sharedManager().hideActivityView()
                            KWSSingleton.sharedInstance.markUserAsUnregistered()
                            KWS.sdk().desetup()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func didObserveAuth () {
        let logged = KWSSingleton.sharedInstance.isUserLogged()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(logged ? "UserNavControllerId" : "SignUpNavControllerId")
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func didObserveSubscribe () {
        SAActivityView.sharedManager().showActivityView()
        
        // user *IS NOT* registered
        if (!KWSSingleton.sharedInstance.isUserMarkedAsRegistered()) {
            
            // define callback
            var callback: ((Bool, KWSErrorType)->Void)!
            callback = { (success: Bool, error: KWSErrorType) in
                
                SAActivityView.sharedManager().hideActivityView()
                
                if (success) {
                    SAPopup.sharedManager().showWithTitle("Great!", andMessage: "Successfully registered for Remote Notifications!", andOKTitle: "OK!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                    KWSSingleton.sharedInstance.markUserAsRegistered()
                } else {
                    if (error == .UserHasNoParentEmail) {
                        KWS.sdk().submitParentEmailWithPopup({ (submitted: Bool) in
                            if (submitted) {
                                SAActivityView.sharedManager().showActivityView()
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
        // user *IS* registered
        else {
            KWS.sdk().unregister({ (success) in
                SAActivityView.sharedManager().hideActivityView()
                let message = success ? "You have successfully un-registered for Remote Notifications in KWS!" : "There was a network error trying to un-register for Remote Notifications in KWS. Please try again!"
                SAPopup.sharedManager().showWithTitle("Hey!", andMessage: message, andOKTitle: "Great", andNOKTitle: nil, andTextField: false, andKeyboardTyle: .Alphabet, andPressed: nil)
                KWSSingleton.sharedInstance.markUserAsUnregistered()
            })
        }
    }
    
    func didObservePerm () {
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
    
    func didObserveAdd20Points () {
        KWS.sdk().triggerEvent("GabrielAdd20ForAwesomeApp", withPoints: 20, andDescription: "You just earned 20 points!") { (success: Bool) in
            if (success) {
                SAPopup.sharedManager().showWithTitle("Congrats!", andMessage: "You just earned 20 points!", andOKTitle: "Great!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: UIKeyboardType.Default, andPressed: nil)
            }
        }
    }
    
    func didObserveSub10Points () {
        KWS.sdk().triggerEvent("GabrielSub10ForAwesomeApp", withPoints: -10, andDescription: "You jost lost 10 points!") { (success: Bool) in
            if (success) {
                SAPopup.sharedManager().showWithTitle("Oh no!", andMessage: "You just lost 10 points!", andOKTitle: "Got it!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: UIKeyboardType.Default, andPressed: nil)
            }
        }
    }
    
    func didObserveGetScore () {
        KWS.sdk().getScore { (score: KWSScore!) in
            if score != nil {
                SAPopup.sharedManager().showWithTitle("Hey!", andMessage: "You're ranked \(score.rank) with \(score.score) points!", andOKTitle: "Great!", andNOKTitle: nil, andTextField: false, andKeyboardTyle: UIKeyboardType.Default, andPressed: nil)
            }
        }
    }
    
    func didObserveSeeLeader () {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("LeaderboardNavControllerId")
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func didObserveDocs () {
        let url = NSURL(string: DOCSURL)
        UIApplication.sharedApplication().openURL(url!)
    }
}
