//
//  BaseCell.swift
//  BugWise
//
//  Created by olbu on 6/11/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation

class BaseCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
