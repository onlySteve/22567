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
    
    @IBOutlet weak var retryButton: BaseRedButton!
    
    @IBInspectable var msgText: String? = "Error retrieving HTML data" {
        didSet {
            msgLabel.text = msgText
        }
    }
    
    private let disposeBag = DisposeBag()

    override func setup() {
        
        
        retryButton
            .rx
            .tap
            .subscribe(onNext: { _ in
                showHud()
                
                delay(1.5, completion: {
                    hideHud()
                })
            }).addDisposableTo(disposeBag)
    }
    
}
