////
////  ApplicationNavigator.swift
////  BugWise
////
////  Created by olbu on 5/31/17.
////  Copyright © 2017 olbu. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//// MARK:- Protocol
//
//protocol ApplicationNavigatorProtocol {
//    func navigateToCurrentApplicationState()
//    func navigateToScreen(screen: UIViewController) -> Bool
//    func presentViewController(screen: UIViewController)
//}
//
//// MARK:- Implementation
//
//class ApplicationNavigator: ApplicationNavigatorProtocol {
//    
//    static let shared: ApplicationNavigatorProtocol = {
////        
////        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
////            
////        }
////        
//        return ApplicationNavigator.init(window: ((UIApplication.shared.delegate?.window)!)!, applicationModel: ApplicationModelFactory.defaultApplicationModelWithApplication(application: UIApplication.shared))
//        
//    }()
//
//    
//    let window: UIWindow
//    let applicationModel: ApplicationModel
//    
//    
//    public init(window: UIWindow, applicationModel: ApplicationModel) {
//        self.window = window
//        self.applicationModel = applicationModel
//    }
//    
//    func navigateToCurrentApplicationState() {
//        switch applicationModel.applicationState {
//            
//        case .NotSignedIn:
//            setCurrentViewController(StarterViewControllerFactory.newViewController())
//        case .HealthCareProvider:
//            setCurrentViewController(StarterViewControllerFactory.newViewController())
//        case .Patient:
//            setCurrentViewController(StarterViewControllerFactory.newViewController())
//        }
//    }
//    
//    func presentViewController(screen: UIViewController) {
//        window.rootViewController?.present(screen, animated: false, completion: nil)
//    }
//    
//    func navigateToScreen(screen: UIViewController) -> Bool {
//        return true
//    }
//    
//    private func setCurrentViewController(_ viewController: UIViewController) {
//        window.rootViewController = viewController
//    }
//}
//
////// MARK:- Factory
////
////class ApplicationNavigatorFactory {
////    static func defaultApplicationNavigatorWithWindow(window: UIWindow, applicationModel: ApplicationModel) -> ApplicationNavigatorProtocol {
////        return ApplicationNavigatorImpl(
////            window: window,
////            applicationModel: applicationModel
////        )
////    }
////}
