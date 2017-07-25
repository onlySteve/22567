//
//  HomeCell.swift
//  BugWise
//
//  Created by olbu on 6/8/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

final class HomeTableViewCell: BaseCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    public func config(with menuType: MenuType) {
        typeImageView.image = menuType.image
        titleLabel.text = menuType.title
    }
}
