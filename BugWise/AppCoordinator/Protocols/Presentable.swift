//
//  Presentable.swift
//  ApplicationCoordinator
//
//  Created by Oleksandr Burov on 23.06.16.
//  Copyright © 2016 Oleksandr Burov. All rights reserved.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController? {
        return self
    }
}
