//
//  ProfileTextField.swift
//  BugWise
//
//  Created by olbu on 6/4/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

@IBDesignable

class ProfileTextField: CommonCustomUIBase {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var separatorView: SeparatorView!
    
    @IBInspectable var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable var inputColor: UIColor = UIColor.black {
        didSet {
            textField.textColor = inputColor
        }
    }
    
    @IBInspectable var separatorColor: UIColor = CommonAppearance.greyColor {
        didSet {
            separatorView.backgroundColor = separatorColor
        }
    }
    
    @IBInspectable var topOffset: CGFloat = 10 {
        didSet {
            topConstraint.constant = topOffset
        }
    }
    
    @IBInspectable var bottomOffset: CGFloat = 9 {
        didSet {
            bottomConstraint.constant = bottomOffset
        }
    }
    
    override func setup() {
        textField.textColor = UIColor.black
        textField.backgroundColor = CommonAppearance.lightGreyColor
        textField.layer.cornerRadius = 5.0
        textField.layer.masksToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    
}
