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
    @IBOutlet weak var actionButtonWidth: NSLayoutConstraint!
    
    @IBOutlet weak var actionButtonPatientWidth: NSLayoutConstraint!
    let disposeBag = DisposeBag()
    
    public func config(with model: ReturnHeaderButtonModel) {
        
        let title = BusinessModel.shared.applicationState == .patient ? "Medicine Reminder" : "Surveillance Data"
        
        if BusinessModel.shared.applicationState == .patient {
            if actionButtonPatientWidth != nil { actionButtonPatientWidth.isActive = true }
            if actionButtonWidth != nil { actionButtonWidth.isActive = false }
        } else {
            if actionButtonPatientWidth != nil { actionButtonPatientWidth.isActive = false }
            if actionButtonPatientWidth != nil { actionButtonWidth.isActive = true }
        }
        
        actionButton.setTitle(title, for: .normal)

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
