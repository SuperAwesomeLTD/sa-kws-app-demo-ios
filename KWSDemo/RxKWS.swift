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
                        andParentEmail parentEmail: String) -> Observable <KWSCreateUserStatus> {
        
        return Observable.create ({ (subscriber) -> Disposable in
         
            KWS.sdk().createUser(username,
                                 withPassword: password,
                                 andDateOfBirth: dateOfBirth,
                                 andCountry: isoCode,
                                 andParentEmail: parentEmail)
            { (status: KWSCreateUserStatus) in
                
                subscriber.onNext(status)
                subscriber.onCompleted()
            }
            
            return Disposables.create ()
        })
        
    }
    
    static func triggerEvent(event: String) -> Observable <Bool> {
        
        return Observable.create({ (subscriber) -> Disposable in
        
            KWS.sdk().triggerEvent(event, withPoints: 20, andResponse: { (triggered) in
                
                subscriber.onNext(triggered)
                subscriber.onCompleted()
                
            })
            
            return Disposables.create()
            
        })
        
    }
    
    static func getScore () -> Observable <KWSScore?> {
        
        return Observable.create({ (subscriber) -> Disposable in
        
            KWS.sdk().getScore({ (score: KWSScore?) in
                
                subscriber.onNext(score)
                subscriber.onCompleted()
                
            })
            
            return Disposables.create()
        })
        
    }
    
    static func getLeaderboard () -> Observable <KWSLeader> {
        
        return Observable.create({ (subscriber) -> Disposable in
            
            KWS.sdk().getLeaderboard({ (leaders: [KWSLeader]?) in
                
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
            
            KWS.sdk().getAppData({ (appData: [KWSAppData]?) in
                
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
          
            KWS.sdk().setAppData(name, withValue: value, andResponse: { (success) in
                
                subscribe.onNext(success)
                subscribe.onCompleted()
                
            })
            
            return Disposables.create()
        })
    }
    
    static func getUser () -> Observable <KWSUser?> {
        
        return Observable.create({ (subscribe) -> Disposable in
        
            KWS.sdk().getUser({ (user: KWSUser?) in
                
                subscribe.onNext(user)
                subscribe.onCompleted()
                
            })
            
            return Disposables.create()
        })
        
    }
    
    static func login (username: String, password: String) -> Observable <KWSAuthUserStatus> {
        
        return Observable.create({ (subscriber) -> Disposable in
            
            KWS.sdk().loginUser(username, withPassword: password, andResponse: { (status: KWSAuthUserStatus) in
                
                subscriber.onNext(status)
                subscriber.onCompleted()
                
            })
            
            return Disposables.create()
        })
        
    }
    
    static func inviteFriend(email: String) -> Observable <Bool> {
        
        return Observable.create({ (subscriber) -> Disposable in
        
            
            KWS.sdk().inviteUser(email) { (isInvited) in
                
                subscriber.onNext(isInvited)
                subscriber.onCompleted()
                
            }
            
            return Disposables.create()
        })
    }
    
    static func addPermissions (permissions: [NSNumber]) -> Observable <KWSPermissionStatus> {
        
        return Observable.create({ (subscriber) -> Disposable in
            
            KWS.sdk().requestPermission(permissions) { (permissionStatus: KWSPermissionStatus) in
                subscriber.onNext(permissionStatus)
                subscriber.onCompleted()
            }
            
            return Disposables.create()
        })
    }
    
    static func registerForNotifications () -> Observable <KWSNotificationStatus> {
        
        return Observable.create({ (subscriber) -> Disposable in
        
            KWS.sdk().register({ (status: KWSNotificationStatus) in
                subscriber.onNext(status)
                subscriber.onCompleted()
            })
            
            return Disposables.create()
        })
        
    }
    
    static func unregisterForNotifications () -> Observable <Bool> {
        
        return Observable.create({ (subscriber) -> Disposable in
            
            KWS.sdk().unregister { (isUnregistered) in
                subscriber.onNext(isUnregistered)
                subscriber.onCompleted()
            }
            
            return Disposables.create()
        })
        
    }
    
    static func getRandomName () -> Observable <String?> {
        
        return Observable.create({ (subscriber) -> Disposable in
            
            KWS.sdk().generateRandomName { (name) in
                subscriber.onNext (name)
                subscriber.onCompleted()
            }
            
            return Disposables.create()
        })
        
    }
    
    static func getRandomName2 () -> PublishSubject <String?> {
        let subject: PublishSubject <String?> = PublishSubject<String?>()
        KWS.sdk().generateRandomName { (name) in
            subject.onNext(name)
        }
        return subject
    }
    
}
