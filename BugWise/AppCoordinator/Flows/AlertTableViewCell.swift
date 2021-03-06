//
//  AlertTableViewCell.swift
//  BugWise
//
//  Created by olbu on 6/10/17.
//  Copyright © 2017 olbu. All rights reserved.
//
import Kingfisher

class AlertTableViewCell: BaseCell {
    
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    static func identifier() -> String {
        let className = AlertTableViewCell.nameOfClass
        
        return BusinessModel.shared.applicationState == .patient ? "\(className)Patient" : className
    }
    
    static func height() -> CGFloat {
        return BusinessModel.shared.applicationState == .patient ? 150.0 : 200.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with alert:AlertEntity) {
        
        if let imagePath = alert.imagePath {
            alertImageView
                .kf
                .setImage(with: URL(string: imagePath),
                          placeholder: UIImage(named: "bg_main"), progressBlock: nil, completionHandler: nil)
        }
        
        titleLabel.attributedText = alert.title?.stringFromHtml(textColor: .white, font: BoldFontWithSize(size: 19))
        subTitleLabel.attributedText = alert.subTitle?.stringFromHtml(textColor: .white, font: RegularFontWithSize(size: 17))
    }
    
}
