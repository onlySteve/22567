//
//  AppSetup.swift
//  BugWise
//
//  Created by olbu on 5/31/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

// MARK:- Protocol

protocol AppSetupType: class {
    var deviceToken: String? { get set }
}

// MARK:- Singleton Implementation

class AppSetup: AppSetupType {
    private static let DeviceTokenKey: String = "DeviceTokenKey"
    
    private(set) static var sharedState: AppSetupType = AppSetup()
    
    
    var deviceToken: String? {
        get {
            return userDefaults.string(forKey: AppSetup.DeviceTokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: AppSetup.DeviceTokenKey)
            userDefaults.synchronize()
        }
    }
    private let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults.standard
    }
}
