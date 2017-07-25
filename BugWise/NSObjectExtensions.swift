//
//  NSObjectExtensions.swift
//  ApplicationCoordinator
//
//  Created by Oleksandr Burov on 08.05.16.
//  Copyright © 2016 Oleksandr Burov. All rights reserved.
//

import Foundation

extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
