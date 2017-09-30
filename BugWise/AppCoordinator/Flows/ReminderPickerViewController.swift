//
//  ReminderPickerViewController.swift
//  BugWise
//
//  Created by olbu on 9/27/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

enum ReminderPickerType {
    case date
    case time
    
    var title: String {
        switch self {
        case .date: return "Pick the date"
        case .time: return "Select time/s a day"
        }
    }
    
    var pickButtonTitle: String {
        switch self {
        case .date: return "Pick"
        case .time: return "Pick time"
        }
    }
    
    var datePickerMode: UIDatePickerMode {
        switch self {
        case .date: return UIDatePickerMode.date
        case .time: return UIDatePickerMode.time
        }
    }
}

enum ReminderPickTimePerDay: Int {
    case one = 1, two, three, four
}

struct ReminderPickedDate {
    var date: Date
    var timePerDay: ReminderPickTimePerDay?
}

class ReminderPickerViewController: BaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet var timesButtonCollection: [UIButton]!
    
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var timesViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pickButton: BaseRedButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var type: ReminderPickerType = .date
    var onPickButtonSelect: ((ReminderPickedDate) -> ())?
    var onCloseButtonSelect: voidBlock?
    var minDate = Date()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTimesCountButtons()
        setupUI()
        setupActions()
    }
    
    // MARK: - Private
    private func setupUI() {
        
        headerLabel.text = type.title
        
        pickButton.setTitle(type.pickButtonTitle, for: .normal)
        
        datePicker.datePickerMode = type.datePickerMode
        
        if type == .date {
            datePicker.minimumDate = minDate
        }
    }
    
    private func setupTimesCountButtons() {
        if type == .time {
            timesButtonCollection.forEach { (button) in
                button.setBackgroundColor(color: UIColor(netHex: 0xC8C7CC), forState: .normal)
                button.setBackgroundColor(color: UIColor(netHex: 0xF05A29), forState: .selected)
                button.layer.cornerRadius = button.frame.size.height/2
                button.layer.masksToBounds = true
                button.setTitleColor(UIColor.white, for: .normal)
                button.tintColor = UIColor.clear
                
                button
                    .rx
                    .tap
                    .subscribe { [weak self] _ in
                        if button.isSelected == false {
                            self?.timesButtonCollection.forEach{ $0.isSelected = false }
                            button.isSelected = true
                        }
                    }.addDisposableTo(disposeBag)
            }
            
            timesButtonCollection.first?.isSelected = true
        } else {
            timesButtonCollection.forEach{ $0.isHidden = true }
            timesViewHeight.constant = 0
        }
    }
    
    private func setupActions() {
        
        pickButton
            .rx
            .tap
            .subscribe { [weak self] _ in
                
                let pickedDate =
                    ReminderPickedDate(date: self?.datePicker.date ?? Date(),
                                       timePerDay: self?.selectedTimes())
                
                self?.onPickButtonSelect?(pickedDate)
                
                self?.closeAnimated(completion: { [weak self] _ in
                    self?.view.removeFromSuperview()
                })
            }.addDisposableTo(disposeBag)
        
        closeButton
            .rx
            .tap
            .subscribe { [weak self] _ in
                self?.closeAnimated(completion: { [weak self] _ in
                    self?.view.removeFromSuperview()
                })
            }.addDisposableTo(disposeBag)
    }
    
    private func selectedTimes() -> (ReminderPickTimePerDay?) {
        if self.type == .date {
            return nil
        }
        
        var result = ReminderPickTimePerDay.one
        
        for (indx, button) in timesButtonCollection.enumerated() {
            if button.isSelected {
                if let selectedCount =  ReminderPickTimePerDay(rawValue: indx+1) {
                    result = selectedCount
                    break;
                }
            }
        }
        
        return result
    }
    
    
    private func closeAnimated(completion: voidBlock? = nil) {
        completion?()
        //        animateView(contentView,
//                    fadeIn: true,
//                    completionBlock: {
//                        completion?()
//        })
    }
    
    private func animateView(_ animatedView: UIView, fadeIn: Bool, completionBlock: @escaping (()->())) -> () {
        
        CATransaction.begin()
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        groupAnimation.beginTime = CACurrentMediaTime()
        groupAnimation.duration = 0.3
        groupAnimation.fillMode = fadeIn ? kCAFillModeForwards : kCAFillModeBackwards
        
        let startPositionY = fadeIn ? view.center.y : view.frame.height*1.5
        
        let endPositionY = fadeIn ? view.frame.height*1.5 : view.center.y
        
        
        let positionY = CABasicAnimation(keyPath: "position.y")
        positionY.fromValue = startPositionY
        positionY.toValue = endPositionY
        
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = fadeIn ? 1.0 : 0.0
        fadeOut.toValue = fadeIn ? 0.0 : 1.0
        
        groupAnimation.animations = [fadeOut, positionY]
        
        CATransaction.setCompletionBlock { _ in
            completionBlock()
        }

        
        animatedView.layer.add(groupAnimation, forKey: nil)
        
        CATransaction.commit()
    }
    
    // MARK: - Public
    public func showAnimated() {
        animateView(contentView, fadeIn: false, completionBlock: {})
    }

}

extension ReminderPickerViewController {
    static func controller(type: ReminderPickerType,
                           minDate: Date? = nil,
                           onPickSelect: ((ReminderPickedDate) -> ())? = nil) -> ReminderPickerViewController {
        
        let controller = ReminderPickerViewController.controllerFromStoryboard(.reminder)
        controller.type = type
        controller.onPickButtonSelect = onPickSelect
        
        if let minDate = minDate {
            controller.minDate = minDate
        }
        
        return controller
    }
}
