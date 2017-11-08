//
//  RxKWS.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 08/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import KWSiOSSDKObjC

enum RxKWSError : Error {
    case NetworkError
}

class RxKWS: NSObject {

    static func signUp (withUsername username: String,
                        andPassword password: String,
                        andBirthdate dateOfBirth: String,
                        andCountryCode isoCode: String,
                        andParentEmail parentEmail: String) -> Observable <KWSChildrenCreateUserStatus> {
        
        return Observable.create ({ (subscriber) -> Disposable in
         
            
            
            KWSChildren.sdk().createUser(username,
                                         withPassword: password,
                                         andDateOfBirth: dateOfBirth,
                                         andCountry: isoCode,
                                         andParentEmail: parentEmail)
            { (status: KWSChildrenCreateUserStatus) in
                
                subscriber.onNext(status)
                subscriber.onCompleted()
            }
            
            return Disposables.create ()
        })
        
    }
    
    static func triggerEvent(event: String) -> Observable <Bool> {
        
        return Observable.create({ (subscriber) -> Disposable in
        
            KWSChildren.sdk().triggerEvent(event, withPoints: 20, andResponse: { (triggered) in
                
                subscriber.onNext(triggered)
                subscriber.onCompleted()
                
            })
            
            return Disposables.create()
            
        })
        
    }
    
    static func getScore () -> Observable <KWSScore?> {
        
        return Observable.create({ (subscriber) -> Disposable in
        
            KWSChildren.sdk().getScore({ (score: KWSScore?) in
                
                subscriber.onNext(score)
                subscriber.onCompleted()
                
            })
            
            return Disposables.create()
        })
        
    }
    
    static func getLeaderboard () -> Observable <KWSLeader> {
        
        return Observable.create({ (subscriber) -> Disposable in
            
            KWSChildren.sdk().getLeaderboard({ (leaders: [KWSLeader]?) in
                
                if let leaders = leaders {
                    
                    for leader in leaders {
                        subscriber.onNext(leader)
                    }
                    subscriber.onCompleted()
                    
                }
                
            })
            
            return Disposables.create()
        })
        
    }
    
    static func getAppData () -> Observable <KWSAppData> {
        
        return Observable.create({ (subscriber) -> Disposable in
            
            KWSChildren.sdk().getAppData({ (appData: [KWSAppData]?) in
                
                if let appData = appData {
                    for data in appData {
                        subscriber.onNext(data)
                     }
                     subscriber.onCompleted()
                } else {
                  subscriber.onError(RxKWSError.NetworkError)
                }
                
            })
            
            return Disposables.create()
        })
        
    }
    
    static func setAppData (name: String, value: Int) -> Observable <Bool> {
        
        return Observable.create({ (subscribe) -> Disposable in
          
            KWSChildren.sdk().setAppData(value, forName: name) { (success) in
                subscribe.onNext(success)
                subscribe.onCompleted()
            }
            
            return Disposables.create()
        })
    }
    
    static func getUser () -> Observable <KWSUser?> {
        
        return Observable.create { (subscribe) -> Disposable in
        
            KWSChildren.sdk().getUser { (user: KWSUser?) in
                
                subscribe.onNext(user)
                subscribe.onCompleted()
                
            }
            
            return Disposables.create()
        }
        
    }
    
    static func login (username: String, password: String) -> Observable <KWSChildrenLoginUserStatus> {
        
        return Observable.create { (subscriber) -> Disposable in
            
            KWSChildren.sdk().loginUser(username, withPassword: password) { (status: KWSChildrenLoginUserStatus) in
                
                subscriber.onNext(status)
                subscriber.onCompleted()
                
            }
            
            return Disposables.create()
        }
        
    }
    
    static func inviteFriend(email: String) -> Observable <Bool> {
        
        return Observable.create { (subscriber) -> Disposable in
        
            
            KWSChildren.sdk().inviteUser(email) { (isInvited) in
                
                subscriber.onNext(isInvited)
                subscriber.onCompleted()
                
            }
            
            return Disposables.create()
        }
    }
    
    static func addPermissions (permissions: [NSNumber]) -> Observable <KWSChildrenRequestPermissionStatus> {
        
        return Observable.create { (subscriber) -> Disposable in
            
            KWSChildren.sdk().requestPermission(permissions) { (permissionStatus: KWSChildrenRequestPermissionStatus) in
                subscriber.onNext(permissionStatus)
                subscriber.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    static func registerForNotifications () -> Observable <KWSChildrenRegisterForRemoteNotificationsStatus> {
        
        return Observable.create { (subscriber) -> Disposable in
        
            KWSChildren.sdk().register { (status: KWSChildrenRegisterForRemoteNotificationsStatus) in
                subscriber.onNext(status)
                subscriber.onCompleted()
            }
            
            return Disposables.create()
        }
        
    }
    
    static func unregisterForNotifications () -> Observable <Bool> {
        
        return Observable.create({ (subscriber) -> Disposable in
            
            KWSChildren.sdk().unregister { (isUnregistered) in
                subscriber.onNext(isUnregistered)
                subscriber.onCompleted()
            }
            
            return Disposables.create()
        })
        
    }
    
    static func getRandomName () -> Observable <String?> {
        
        return Observable.create({ (subscriber) -> Disposable in
            
            KWSChildren.sdk().getRandomUsername { (name) in
                subscriber.onNext (name)
                subscriber.onCompleted()
            }
            
            return Disposables.create()
        })
        
    }
    
    static func getRandomName2 () -> PublishSubject <String?> {
        let subject: PublishSubject <String?> = PublishSubject<String?>()
        KWSChildren.sdk().getRandomUsername { (name) in
            subject.onNext(name)
        }
        return subject
    }
    
}
