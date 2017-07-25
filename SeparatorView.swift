//
//  SeparatorView.swift
//  BugWise
//
//  Created by olbu on 5/30/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

class SeparatorView: UIView {
    
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
        self.backgroundColor = CommonAppearance.greyColor
    }
}
