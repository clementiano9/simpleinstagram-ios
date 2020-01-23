//
//  UserManager.swift
//  SimpleInstagram
//
//  Created on 23/01/2020.
//  Copyright © 2020 clementozemoya. All rights reserved.
//

import Foundation

struct UserManager {
    
    enum UserAccountKey: String {
        case isUserLoggedIn
        case token
        case userId
        case name
    }
    
    static func setLoggedIn(token: String) {
        UserDefaults.standard.set(true, forKey: UserAccountKey.isUserLoggedIn.rawValue)
        UserDefaults.standard.set(token, forKey: UserAccountKey.token.rawValue)
    }
    
    static func isUserLoggedIn() -> Bool {
           return UserDefaults.standard.bool(forKey: UserAccountKey.isUserLoggedIn.rawValue)
       }
       
    static func setUserLoggedOut() {
        UserDefaults.standard.set(false, forKey: UserAccountKey.isUserLoggedIn.rawValue)
        UserDefaults.standard.removeObject(forKey: UserAccountKey.token.rawValue)
    }
    
    static func getToken() -> String? {
        return UserDefaults.standard.string(forKey: UserAccountKey.token.rawValue) ?? nil
    }
}
