//
//  PinCodeCoordinator.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import RxSwift

// MARK:- Protocol

protocol PinCodeCoordinatorOutput: class {
    var finishFlow: (()->())? { get set }
}

// MARK:- Implementation

final class PinCodeCoordinator: BaseCoordinator, PinCodeCoordinatorOutput {
    
    var finishFlow: (()->())?
    
    
    private let factory: PinCodeModuleFactory
    private let router: Router
    
    init(router: Router,
         factory: PinCodeModuleFactory) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showPinCode()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showPinCode() {
        
        let pinCodeOutput = factory.makePinCodeOutput()
        pinCodeOutput.onComplete = { pinCode in
            BusinessModel.shared.usr.pinCode.value = pinCode
            self.finishFlow?()
        }
        
        router.push(pinCodeOutput, animated: true)
    }
    
}
