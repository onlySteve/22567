//
//  UIButtonExtensions.swift
//  BugWise
//
//  Created by olbu on 5/31/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        let image = UIImage.imageWithColor(color)
        setBackgroundImage(image, for: forState)
    }
}
