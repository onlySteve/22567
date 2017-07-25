//
//  CalculatorField.swift
//  BugWise
//
//  Created by olbu on 6/27/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

@IBDesignable

class CalculatorField: CommonCustomUIBase, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBInspectable var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    @IBInspectable var measureText: String? {
        didSet {
            measureLabel.text = measureText
        }
    }
    
    @IBInspectable var inputColor: UIColor = UIColor(netHex: 0x347FBE) {
        didSet {
            valueTextField.textColor = inputColor
        }
    }
    
    @IBInspectable var titleLineCount: Int = 1 {
        didSet {
            titleLabel.numberOfLines = titleLineCount
        }
    }
    
    private let disposeBag = DisposeBag()
    
    override func setup() {
        titleLabel.textColor = UIColor(netHex: 0x1F62AE)
        titleLabel.font = RegularFontWithSize(size: 14)
        
        measureLabel.font = RegularFontWithSize(size: 16)
        
        valueTextField.font = RegularFontWithSize(size: 17)
        valueTextField.layer.backgroundColor = CommonAppearance.lightGreyColor.cgColor
        valueTextField.layer.cornerRadius = 3
        valueTextField.layer.masksToBounds = true
        valueTextField.textColor =  UIColor(netHex: 0x347FBE)
        
        valueTextField.delegate = self
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return string.containsOnlyNumberCharacter || string.characters.count == 0
    }
}
