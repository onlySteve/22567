//
//  InteractionsResultTableViewCell.swift
//  BugWise
//
//  Created by olbu on 7/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

final class InteractionsResultTableViewCell: BaseCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = CommonAppearance.boldGreyColor
        titleLabel.font = RegularFontWithSize()
        
        descriptionLabel.font = RegularFontWithSize(size: 14)
    }
    
    public func config(with entity: InteractionsDetailEntity, separatorVisible: Bool) {
        titleLabel.text = entity.category
        descriptionLabel.text = entity.desc
        
        separatorView.isHidden = !separatorVisible
    }
    
    
}

