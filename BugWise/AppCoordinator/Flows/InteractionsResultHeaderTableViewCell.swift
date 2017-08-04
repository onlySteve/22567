//
//  InteractionsResultHeaderView.swift
//  BugWise
//
//  Created by olbu on 7/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

@IBDesignable

class InteractionsResultHeaderTableViewCell: BaseCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = CommonAppearance.blueColor
        statusImage.image = nil
    }
    
    public func config(with entity: InteractionsEntity, separatorVisible: Bool) {
        if let image = entity.severityType?.image {
            statusImage.image = image
        }
        
        titleLabel.text = String(format: "%@\nand\n%@", entity.firstMedcine ?? "", entity.secondMedcine ?? "")
        descLabel.text = entity.severityType?.title
        
        separatorView.isHidden = !separatorVisible
    }
}


