//
//  AlertContentController.swift
//  BugWise
//
//  Created by olbu on 6/11/17.
//  Copyright © 2017 olbu. All rights reserved.
//

class AlertDetailedController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    private var alert: AlertEntity = AlertEntity()
    
    override func viewDidLoad() {
        
        titleLabel.attributedText = alert.title?.stringFromHtml(textColor: CommonAppearance.blueColor, font: BoldFontWithSize(size: 17))
        subTitleLabel.attributedText = alert.subTitle?.stringFromHtml(textColor: CommonAppearance.boldGreyColor, font: RegularFontWithSize(size: 15))
        
        contentLabel.attributedText = alert.content?.stringFromHtml(font: RegularFontWithSize(size: 13))
    }
    
    
    static func controller(with alert: AlertEntity) -> AlertDetailedController {
        let controller = AlertDetailedController.controllerFromStoryboard(.home)
        
        controller.alert = alert

        return controller
    }
}
