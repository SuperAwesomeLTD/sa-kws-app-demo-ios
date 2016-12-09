//
//  SignUpModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 08/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import SAUtils

class SignUpModel: NSObject {

    private let INVALID_DATE: Int = -Int.max
    
    private var username: String?
    private var password1: String?
    private var password2: String?
    private var parrentEmail: String?
    private var year: Int?
    private var month: Int?
    private var day: Int?
    
    init(withUsername username: String?,
         andPassword1 password1: String?,
         andPassword2 password2: String?,
         andParentEmail parentEmail: String?,
         andYear year: String?,
         andMonth month: String?,
         andDay day: String?) {
        super.init()
        
        self.username = username
        self.password1 = password1
        self.password2 = password2
        self.parrentEmail = parentEmail
        if let year = year {
            self.year = Int(year)
        }
        if let month = month {
            self.month = Int(month)
        }
        if let day = day {
            self.day = Int(day)
        }
    }
    
    static func createEmpty () -> SignUpModel {
        return SignUpModel (withUsername: nil, andPassword1: nil, andPassword2: nil, andParentEmail: nil, andYear: nil, andMonth: nil, andDay: nil)
    }
    
    func isUserOK () -> Bool {
        if let username = username {
            return !username.isEmpty
        }
        return false
    }
    
    func isPassword1OK () -> Bool {
        if let password1 = password1 {
            return !password1.isEmpty && password1.characters.count >= 8
        }
        return false
    }
    
    func isPassword2OK () -> Bool {
        if let password2 = password2 {
            return !password2.isEmpty && password2.characters.count >= 8
        }
        return false
    }
    
    func arePasswordsSame () -> Bool {
        if let password1 = password1, let password2 = password2 {
            return password1 == password2
        }
        return false
    }
    
    func isParentEmailOK () -> Bool {
        if let parrentEmail = parrentEmail {
            return SAUtils.isEmailValid(parrentEmail)
        }
        return false
    }
    
    func isYearOK () -> Bool {
        if let year = year {
            return year > 1900
        }
        return false
    }
    
    func isMonthOK () -> Bool {
        if let month = month {
            return month >= 1 && month <= 12
        }
        return false
    }
    
    func isDayOK () -> Bool {
        if let day = day {
            return day >= 1 && day <= 31
        }
        return false
    }
    
    func isValid () -> Bool {
        return isUserOK() && isPassword1OK() && isPassword2OK() && arePasswordsSame() && isParentEmailOK() && isYearOK() && isMonthOK() && isDayOK()
    }
    
    func getParentEmail () -> String {
        if let parentEmail = parrentEmail {
            return parentEmail
        }
        return ""
    }
    
    func getUsername () -> String {
        if let username = username {
            return username
        }
        return ""
    }
    
    func getPassword () -> String {
        if let password1 = password1 {
            return password1
        }
        return ""
    }
    
    func getDate () -> String {
        if let year = year, let month = month, let day = day {
            let yearStr = "\(year)"
            let monthStr = month < 10 ? "0\(month)" : "\(month)"
            let dayStr = day < 10 ? "0\(day)" : "\(day)"
            return "\(yearStr)-\(monthStr)-\(dayStr)"
        }
        return ""
    }
}
