//
//  DisclaimerController.swift
//  BugWise
//
//  Created by olbu on 6/4/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class DisclaimerViewController: UIViewController {

    public var onAgreeButtonAction: (() -> ())?
    public var onDisAgreeButtonAction: (() -> ())?
    public var preview: Bool = false
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var disclaimerView: UIView!
    @IBOutlet weak var agreeButton: BaseRedButton!
    @IBOutlet weak var disagreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if preview {
            disagreeButton.isHidden = true
            agreeButton.setTitle("OK", for: .normal)
        }
        
        agreeButton
            .rx
            .tap
            .subscribe(onNext: { _ in
                self.onAgreeButtonAction?()
                self.view.removeFromSuperview()
            }).addDisposableTo(disposeBag)
        
        if disagreeButton.isHidden { return }
        
        disagreeButton
            .rx
            .tap
            .subscribe(onNext: { _ in
                self.onDisAgreeButtonAction?()
                self.view.removeFromSuperview()
            }).addDisposableTo(disposeBag)
    }
    
    // MARK: - Public
    public func showAnimated() {
        animateView(disclaimerView, fadeIn: false, completionBlock: {})
    }
    
    // MARK: - Private
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
        
        CATransaction.setCompletionBlock {
            completionBlock()
        }
        
        animatedView.layer.add(groupAnimation, forKey: nil)
        
        CATransaction.commit()
    }
}

extension DisclaimerViewController {
    static func controller() -> DisclaimerViewController {
        let controller = DisclaimerViewController.controllerFromStoryboard(.tabBar)
        
        return controller
    }
    
}
