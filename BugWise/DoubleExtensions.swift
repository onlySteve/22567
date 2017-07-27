//
//  DoubleExtensions.swift
//  BugWise
//
//  Created by olbu on 7/27/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

extension Double {
    var stringValue: String? {
        return Number.numberFormatter.string(from: NSNumber(value: self))
    }
}
