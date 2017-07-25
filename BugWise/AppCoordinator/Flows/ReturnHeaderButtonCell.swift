//
//  ReturnHeaderButtonCell.swift
//  BugWise
//
//  Created by olbu on 6/17/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxSwift
import RxCocoa

class ReturnHeaderButtonCell: UITableViewCell {
    
    @IBOutlet weak var actionButton: BaseRedButton!
    
    let disposeBag = DisposeBag()
    
    public func config(with model: ReturnHeaderButtonModel) {
        
        if let action = model.action {
            actionButton
                .rx
                .tap
                .asObservable()
                .bindNext{ action() }
                .addDisposableTo(disposeBag)
        }
    }
}
