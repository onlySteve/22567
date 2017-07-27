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
                    self.runMainFlow()
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
        
//        let coordinator = coordinatorFactory.makeTabBarCoordinator(router: router)
//        
//        coordinator.finishFlow = { [weak self] flow in
//            
//            self?.router.dismissModule()
//            self?.removeDependency(coordinator)
//            self?.router.popToRootModule(animated: false)
//        }
//        
//        coordinator.onBackAction = { [weak self] in
//            
//            self?.router.dismissModule()
//            self?.removeDependency(coordinator)
//        }
//
//        addDependency(coordinator)
//        coordinator.start()
    }
}


