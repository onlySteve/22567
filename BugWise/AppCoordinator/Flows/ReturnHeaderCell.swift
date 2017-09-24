//
//  ReturnHeaderCell.swift
//  BugWise
//
//  Created by olbu on 6/17/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxSwift
import RxCocoa

class ReturnHeaderCell: UITableViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var tradesButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    public func config(with model: ReturnHeaderModel) {
        
        switch model.type {
        case .infections: typeImageView.image = #imageLiteral(resourceName: "bg_infection")
            break
        case .antibiotics:
            
            var image = ReturnSectionHeaderImage.oral.image
            
            if BusinessModel.shared.applicationState != .patient {
                if let stringType = model.titleImage, let headerImageType = ReturnSectionHeaderImage(rawValue: stringType) {
                    image = headerImageType.image
                }
            }
            
            typeImageView.image = image
            
            break
        case .microbes: typeImageView.image = #imageLiteral(resourceName: "bg_microbe")
            break
        }
        
        if let imagePath = model.imagePath {
            typeImageView.kf.setImage(with: URL(string: imagePath), placeholder: typeImageView.image, options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        titleLabel.font = BoldFontWithSize(size: 19)
        
        tradesButton.titleLabel?.font = BoldFontWithSize(size: 18)
        
        subTitleLabel.font = RegularFontWithSize(size: 13)
        
        subTitleLabel.text = model.subtitle
        titleLabel.text = model.title
        
        if let action = model.tradeAction {
            tradesButton.isHidden = false
            
            tradesButton
                .rx
                .tap
                .asObservable()
                .bindNext{ action() }
                .addDisposableTo(disposeBag)
        }
    }
}
