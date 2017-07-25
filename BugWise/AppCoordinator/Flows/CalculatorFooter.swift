//
//  CalculatorFooter.swift
//  BugWise
//
//  Created by olbu on 6/28/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxSwift
import RxCocoa

struct CalculatorFooterModel {
    var title: String?
    var formula: String?
    var notes: String?
}

@IBDesignable

class CalculatorFooter: CommonCustomUIBase {
    
    @IBOutlet weak var formulaTitleLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var disclaimerTextLabel: UILabel!
    
    @IBOutlet weak var formulaDescLabel: UILabel!
    @IBOutlet weak var disclaimerTitleLabel: UILabel!
    @IBOutlet weak var showDisclaimerButton: UIButton!
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var formulaBottomConstraint: NSLayoutConstraint!
    
    override func setup() {
        formulaTitleLabel.font = BoldFontWithSize(size: 15)
        formulaLabel.textColor = CommonAppearance.lighBlueColor
        formulaLabel.font = BoldFontWithSize(size: 13)
        
        formulaDescLabel.font = RegularFontWithSize(size: 13)
        formulaDescLabel.textColor = CommonAppearance.boldGreyColor
        
        disclaimerTitleLabel.font = BoldFontWithSize(size: 15)
        
        disclaimerTextLabel.font = RegularFontWithSize(size: 14)
        disclaimerTextLabel.text = "The results contained in and produced by this tool are for educational and informational purposes only and should not be the basis for the diagnosis or treatment of a patient's health concern or replace  decision making. No declarations are made or inferred regarding the accuracy of calculations. No liability will be accepted by the authors for any harm that comes from its use."
        
        disclaimerTextLabel.textColor = CommonAppearance.boldGreyColor
    }
    
    func config(with model: CalculatorFooterModel) {
        
        formulaTitleLabel.text = model.title
        
        formulaLabel.text = model.formula
        formulaDescLabel.text = model.notes
        if model.notes == nil {
            formulaBottomConstraint.constant = 0
        }

        showDisclaimerButton
            .rx
            .tap
            .subscribe(onNext: { _ in
                showPreviewDisclaimerAlert()
            }).addDisposableTo(disposeBag)
    }
}
