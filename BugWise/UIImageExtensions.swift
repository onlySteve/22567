//
//  UIImageExtensions.swift
//  BugWise
//
//  Created by olbu on 5/31/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

extension UIImage {
    // TODO: remove implicit nil unwrapping
    static func imageWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return colorImage!
    }
}
