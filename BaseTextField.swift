//
//  BaseTextField.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func setup() {
        self.font = RegularFontWithSize()
        self.textColor = UIColor(netHex: 0x000000)
    }
}
