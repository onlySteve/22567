//
//  CoordinatorFactory.swift
//  ApplicationCoordinator
//
//  Created by Oleksandr Burov on 24/05/16.
//  Copyright © 2016 Oleksandr Burov. All rights reserved.
//

import UIKit

// MARK:- Factory

protocol CoordinatorFactory {
    
    func makeStartCoordinator(router: Router) -> Coordinator & StartCoordinatorOutput
    
    func makePinCodeCoordinator(router: Router) -> Coordinator & PinCodeCoordinatorOutput
    
    func makeTabBarCoordinator() -> (configurator: Coordinator & TabBarCoordinatorOutput, toPresent: Presentable?)
    
    func makeProfileCoordinator(navController: UINavigationController?) -> Coordinator & ProfileCoordinatorOutput
    
    func makeHomeCoordinator(navController: UINavigationController?) -> Coordinator    
}
