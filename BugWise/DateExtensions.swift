//
//  DateExtensions.swift
//  BugWise
//
//  Created by olbu on 9/4/17.
//  Copyright © 2017 olbu. All rights reserved.
//

extension Date {
    public static let dateFormatterUTC: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    public var UTC: String {
        return Date.dateFormatterUTC.string(from: self)
    }
    
    public static let bgWiseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a ZZZ"
        formatter.timeZone = TimeZone.current
        formatter.calendar = Calendar.current
        return formatter
    }()

    public var bgWiseString: String {
        return Date.bgWiseDateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}
