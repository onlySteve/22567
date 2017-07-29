//
//  TabBarController.swift
//  BugWise
//
//  Created by olbu on 6/3/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import RxSwift

final class TabBarController: UITabBarController, UITabBarControllerDelegate, TabBarView {
    
    // MARK:- Controller handler
    
    var onComplete: (()->())? 
    var onBack: (()->())? 
    var selectHomeBar: (() -> ())?
    
    
    var onHomeFlowSelect: ((UINavigationController) -> ())? 
    var onAboutFlowSelect: ((UINavigationController) -> ())? 
    var onFavouritesFlowSelect: ((UINavigationController) -> ())? 
    var onLogoutFlowSelect: (()->())? 
    var onProfileFlowSelect: ((UINavigationController) -> ())? 
    var onViewDidLoad: ((UINavigationController) -> ())?
    
    private var blockAllTabs: Bool = true
    
    
    private enum ControllersOrder: Int {
        case home = 0, profile, favourites, about, disclaimer, logout
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
                
        delegate = self
        
        setupTabBarAppearance()
        
//        BusinessModel.shared.usr.loggedIn
//            .asObservable()
//            .distinctUntilChanged()
//            .filter({ $0 == true })
//            .subscribe { [weak self] in
//                
//            }.disposed(by: disposeBag)
//        
        
        BusinessModel.shared.usr.loggedIn
            .asObserver()
            .subscribe { value in
                
                guard let value = value.element else { return }
                
                if value == true {
                    self.selectHome()
                } else {
                    self.selectProfile()
                }
                
                self.blockAllTabs = !value
                
            }.addDisposableTo(disposeBag)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarController.selectHome), name: showHomeTabNotificationName, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: showHomeTabNotificationName, object: nil);
    }
    
    // MARK:- Private
    
    private func selectProfile() {
        selectedIndex = ControllersOrder.profile.rawValue
        
        if let controller = customizableViewControllers?[ControllersOrder.profile.rawValue] as? UINavigationController {
            
            onViewDidLoad?(controller)
        }
    }
    
    @objc private func selectHome() {
        self.selectedIndex = ControllersOrder.home.rawValue
        
        if let controller = self.customizableViewControllers?[ControllersOrder.home.rawValue] as? UINavigationController {
            
            self.onHomeFlowSelect?(controller)
        }
    }
    
    private func setupTabBarAppearance() {
        tabBar.barTintColor = TabBarAppearance.backgroundColor
        let tabBarAppearance = UITabBarItem.appearance()
        tabBarAppearance.setTitleTextAttributes(TabBarAppearance.textAttributes, for: .normal)
        
        tabBar.tintColor = TabBarAppearance.itemsColor
    }
    
    // MARK:- UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        
        switch ControllersOrder(rawValue: selectedIndex)! {
        case .home: onHomeFlowSelect?(controller)
            break
        case .profile: onProfileFlowSelect?(controller)
            break
        case .favourites: onFavouritesFlowSelect?(controller)
            break
        case .about: onAboutFlowSelect?(controller)
            break
        case .logout:
//            BusinessModel.shared.performLogout()
            break
        case .disclaimer:
            break
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if blockAllTabs { return false }
        
        guard let selectedIndx = viewControllers?.index(of: viewController) else { return true }
        
        switch ControllersOrder(rawValue: selectedIndx)! {
        case .disclaimer:
            showDisclaimerAlert(preview: true, agreeAction: nil, disagreeAction: nil)
            return false
            
        default:
            return true
        }
    }
}
