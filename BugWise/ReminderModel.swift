//
//  ReminderModel.swift
//  BugWise
//
//  Created by olbu on 9/28/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation
import RxSwift

fileprivate enum SynchronizeReminder: String {
    case antibioticName = "ReminderAntibiotic"
    case startDate = "ReminderStartDate"
    case startTime = "ReminderStartTime"
    case endDate = "ReminderEndDate"
    case timesPerDay = "ReminderTimesPerDay"
    case reminderEnabled = "ReminderEnabled"
}

class ReminderModel {
    var antibioticName: String? {
        get{
            return UserDefaults.standard.string(forKey: SynchronizeReminder.antibioticName.rawValue)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: SynchronizeReminder.antibioticName.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    var startTime: Date? {
        get{
            guard let timeStr = UserDefaults.standard.string(forKey: SynchronizeReminder.startTime.rawValue), let date = Date.bgWiseDateFormatter.date(from: timeStr) else {
                return nil
            }
            
            return date
            
        }
        set{
            
            UserDefaults.standard.set(newValue?.bgWiseString, forKey: SynchronizeReminder.startTime.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    var startDate: Date? {
        get{
            guard let timeStr = UserDefaults.standard.string(forKey: SynchronizeReminder.startDate.rawValue), let date = Date.bgWiseDateFormatter.date(from: timeStr) else {
                return nil
            }
            
            return date
            
        }
        set{
            UserDefaults.standard.set(newValue?.bgWiseString, forKey: SynchronizeReminder.startDate.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    var endDate: Date? {
        get{
            guard let timeStr = UserDefaults.standard.string(forKey: SynchronizeReminder.endDate.rawValue), let date = Date.bgWiseDateFormatter.date(from: timeStr) else {
                return nil
            }
            
            return date
            
        }
        set{
            
            UserDefaults.standard.set(newValue?.bgWiseString, forKey: SynchronizeReminder.endDate.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    var timesPerDay: Int? {
        get{
            guard let timesPerDay = UserDefaults.standard.value(forKey: SynchronizeReminder.timesPerDay.rawValue) as? Int else {
                return nil
            }
            
            return timesPerDay
            
        }
        set{
            
            UserDefaults.standard.set(newValue, forKey: SynchronizeReminder.timesPerDay.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var isEnabled: Bool {
        get{
            return UserDefaults.standard.bool(forKey: SynchronizeReminder.reminderEnabled.rawValue)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: SynchronizeReminder.reminderEnabled.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
