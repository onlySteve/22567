//
//  TabBarCoordinator.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

// MARK:- Protocol

protocol TabBarCoordinatorOutput: class {
    var onLogoutFlow: (()->())? { get set }
    var onBackAction: (()->())? { get set }
}

// MARK:- Implementation

final class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorOutput {
    
    internal var onBackAction: (() -> ())?
    internal var onLogoutFlow: (()->())?
    private let tabBarView: TabBarView
    private let coordinatorFactory: CoordinatorFactory
    
    var homeCoordinator: HomeCoordinator?
    
    init(tabbarView: TabBarView, coordinatorFactory: CoordinatorFactory) {
        self.tabBarView = tabbarView
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        tabBarView.onViewDidLoad = runProfileFlow()
        tabBarView.onHomeFlowSelect = runHomeFlow()
        tabBarView.onAboutFlowSelect = runAboutFlow()
        tabBarView.onFavouritesFlowSelect = runFavouritesFlow()
        tabBarView.onLogoutFlowSelect = { [weak self] in
            self?.onLogoutFlow?()
        }
        tabBarView.onProfileFlowSelect = runProfileFlow()
    }
        
    private func runHomeFlow() -> ((UINavigationController) -> ()) {
        return { navController in
            if navController.viewControllers.isEmpty == true {
                self.homeCoordinator = self.coordinatorFactory.makeHomeCoordinator(navController: navController) as? HomeCoordinator
                
                guard let coordinator = self.homeCoordinator else {
                    return
                }
                
                coordinator.start()
                self.addDependency(coordinator)
            }
        }
    }
    
    private func runProfileFlow() -> ((UINavigationController) -> ()) {
        return { navController in
            if navController.viewControllers.isEmpty == true {
                let profileCoordinator = self.coordinatorFactory.makeProfileCoordinator(navController: navController)
                
                profileCoordinator.onBackAction = { [weak self] in
                    self?.onBackAction?()
                }
                
                profileCoordinator.start()
                self.addDependency(profileCoordinator)
            }
        }
    }
    
    private func runFavouritesFlow() -> ((UINavigationController) -> ()) {
        return { navController in
            if navController.viewControllers.isEmpty == true {
                
                let favController = FavouritesViewController.controller()
                
                favController.onItemSelect = { [weak self] (item) in
                    self?.homeCoordinator?.showDetailedFromFavourite(searchItem: item)
                }
                
                navController.setViewControllers([favController], animated: false)

            }
        }
    }
    
    private func runAboutFlow() -> ((UINavigationController) -> ()) {
        return { navController in
            if navController.viewControllers.isEmpty == true {
                navController.setViewControllers([AboutViewController.controller()], animated: false)
            }
        }
    }
    
    private func runAlertsFlow() {
        
    }
}
