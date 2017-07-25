//
//  CommonTitleHeaderView.swift
//  BugWise
//
//  Created by olbu on 7/1/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

@IBDesignable

class CommonTitleHeaderView: CommonCustomUIBase {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor(netHex: 0x005BB4) {
        didSet {
            titleLabel.textColor = textColor
        }
    }
    
    override func setup() {
      
    }
    
    
}

