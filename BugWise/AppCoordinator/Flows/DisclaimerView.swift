//
//  DisclaimerView.swift
//  BugWise
//
//  Created by olbu on 7/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxSwift
import RxCocoa


@IBDesignable

class DisclaimerView: CommonCustomUIBase {
    
    @IBOutlet weak var separatorView: SeparatorView!
    @IBOutlet weak var disclaimerTextLabel: UILabel!
    
    @IBOutlet weak var disclaimerTitleLabel: UILabel!
    @IBOutlet weak var showDisclaimerButton: UIButton!
    
    @IBInspectable var discalimerText: String? {
        didSet {
            disclaimerTextLabel.text = discalimerText
        }
    }
    
    @IBInspectable var topSeparatorHidden: Bool = false {
        didSet {
            separatorView.isHidden = topSeparatorHidden
        }
    }
    
    private let disposeBag = DisposeBag()
    
    override func setup() {
        
        disclaimerTextLabel.font = RegularFontWithSize(size: 14)
        
        showDisclaimerButton
            .rx
            .tap
            .subscribe(onNext: { _ in
                showPreviewDisclaimerAlert()
            }).addDisposableTo(disposeBag)
    }
}

