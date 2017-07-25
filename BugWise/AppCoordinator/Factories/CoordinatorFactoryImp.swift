//
//  CoordinatorFactory.swift
//  ApplicationCoordinator
//
//  Created by Oleksandr Burov on 21.04.16.
//  Copyright © 2016 Oleksandr Burov. All rights reserved.
//
import UIKit

final class CoordinatorFactoryImp: CoordinatorFactory {
    
    func makeStartCoordinator(router: Router) -> Coordinator & StartCoordinatorOutput {
        let coordinator = StartCoordinator(router: router, factory: ModuleFactoryImp())
        return coordinator
    }
    
    func makePinCodeCoordinator(router: Router) -> Coordinator & PinCodeCoordinatorOutput {
        let coordinator = PinCodeCoordinator(router: router, factory: ModuleFactoryImp())
        return coordinator
    }
    
    
    func makeTabBarCoordinator() -> (configurator: Coordinator & TabBarCoordinatorOutput, toPresent: Presentable?) {
        let controller = TabBarController.controllerFromStoryboard(.tabBar)
        let coordinator = TabBarCoordinator(tabbarView: controller, coordinatorFactory: CoordinatorFactoryImp())
        return (coordinator, controller)
    }
    
    func makeProfileCoordinator(navController: UINavigationController?) -> Coordinator & ProfileCoordinatorOutput {
        let coordinator = ProfileCoordinator(router: router(navController), factory: ModuleFactoryImp(), coordinatorFactory: CoordinatorFactoryImp())
        return coordinator as Coordinator & ProfileCoordinatorOutput
    }
    
    func makeHomeCoordinator(navController: UINavigationController?) -> Coordinator   {
        let coordinator = HomeCoordinator(router: router(navController), factory: ModuleFactoryImp(), coordinatorFactory: CoordinatorFactoryImp())
        return coordinator
    }
    
        
    //MARK: Private Helpers
    private func router(_ navController: UINavigationController?) -> Router {
        return RouterImp(rootController: navigationController(navController))
    }
    
    private func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        
        if let navController = navController { return navController }
        else { return UINavigationController.controllerFromStoryboard(.start) }
    }
}
