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
    
    public var UTC : String {
        return Date.dateFormatterUTC.string(from: self)
    }
    
}
