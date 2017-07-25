//
//  AuthControllersFactory.swift
//  ApplicationCoordinator
//
//  Created by Oleksandr Burov on 08.05.16.
//  Copyright © 2016 Oleksandr Burov. All rights reserved.
//

final class ModuleFactoryImp:
            StartModuleFactory,
            PinCodeModuleFactory,
            TabBarModuleFactory,
            ProfileModuleFactory,
            HomeModuleFactory,
            SearchModuleFactory {

    func makeStartOutput() -> StartView {
        return StartViewController.controllerFromStoryboard(.start)
    }
    
    func makePinCodeOutput() -> PinCodeView {
        return PinCodeViewController.controllerFromStoryboard(.start)
    }
    
    func makeTabBarOutput() -> TabBarView {
        return TabBarController.controllerFromStoryboard(.tabBar)
    }
    
    func makeProfileOutput() -> ProfileView {
        return ProfileViewController.controllerFromStoryboard(.tabBar)
    }
    
    func makeHomeOutput() -> HomeView {
        return HomeViewController.controllerFromStoryboard(.home)
    }
    
    func makeSearchOutput() -> SearchView {
        return SearchController.controllerFromStoryboard(.search)
    }
}
