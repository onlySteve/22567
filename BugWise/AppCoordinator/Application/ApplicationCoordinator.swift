//
//  ApplicationCoordinator.swift
//  ApplicationCoordinator
//
//  Created by Oleksandr Burov on 21.02.16.
//  Copyright © 2016 Oleksandr Burov. All rights reserved.
//

import UIKit
import RxSwift

final class ApplicationCoordinator: BaseCoordinator {

    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private let disposeBag = DisposeBag()
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        
        BusinessModel.shared.usr.loggedIn
            .asObserver()
            .distinctUntilChanged()
            .subscribe { value in
                guard let value = value.element else { return }
                
                if value {
                    self.updateOnStart()
                } else {
                    self.runStarterFlow()
                }
                
            }.addDisposableTo(disposeBag)
    }
    
    //MARK: - Run coordinators (switch to another flow)
    
    private func runStarterFlow() {
        let coordinator = coordinatorFactory.makeStartCoordinator(router: router)
        coordinator.finishFlow = { [weak self] flow in
            //TODO: - Add Flow status to bussines logic model
            switch flow {
            case .healthCareProvider: self?.runPinCodeCoordinator()
            case .patient: return
            }
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    
    private func runPinCodeCoordinator() {
        let coordinator = coordinatorFactory.makePinCodeCoordinator(router: router)
        coordinator.finishFlow = { [weak self] flow in
            self?.runMainFlow()
        }
        addDependency(coordinator)
                
        coordinator.start()
    }
    
    private func runMainFlow() {
        
        let (coordinator, module) = coordinatorFactory.makeTabBarCoordinator()
        coordinator.onLogoutFlow = { [weak self] in
            self?.removeDependency(coordinator)
            self?.runStarterFlow()
        }
        coordinator.onBackAction = { [weak self] in
            self?.removeDependency(coordinator)
            self?.runPinCodeCoordinator()
        }
        
        addDependency(coordinator)
        router.setRootModule(module, hideBar: true)
        coordinator.start()
    }
    
    private func updateOnStart() {
        
        if BusinessModel.shared.notReachableNetwork {
            runMainFlow()
            return
        }
        
        let splashScreen = StartSplashController.controllerFromStoryboard(.start)
        
        self.router.setRootModule(splashScreen, hideBar: true)
        
        showHud()
        
        BusinessModel.shared.performLogIn(onSuccess: { [weak self] _ in
            splashScreen.dismiss(animated: true, completion: nil)
            hideHud()
            self?.runMainFlow()
            
        }, onFail: { (errorMsg) in
            
            hideHud()
            
            let alertController = alertWith(title: "", message: errorMsg ?? "", okAction: { [weak self] _ in
                self?.runStarterFlow()
            })
            
            UIApplication.shared.keyWindow?.topMostController()?.present(alertController, animated: true, completion: nil)
        })
    }

}


