//
//  BaseSearchBar.swift
//  BugWise
//
//  Created by olbu on 6/13/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

class BaseSearchBar: UISearchBar {
    
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
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = CommonAppearance.lighBlueColor
        textFieldInsideSearchBar?.placeholder = "Search"
    }

}
