//
//  PlaceholderView.swift
//  BugWise
//
//  Created by olbu on 7/22/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxSwift
import RxCocoa

@IBDesignable

class PlaceholderView: CommonCustomUIBase {
    
    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var backButton: BaseRedButton!
    
    @IBInspectable var msgText: String? = "Error retrieving HTML data" {
        didSet {
            msgLabel.text = msgText
        }
    }
    
    private let disposeBag = DisposeBag()
    
}
