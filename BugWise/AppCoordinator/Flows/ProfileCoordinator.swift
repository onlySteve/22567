//
//  ProfileCoordinator.swift
//  BugWise
//
//  Created by olbu on 6/5/17.
//  Copyright © 2017 olbu. All rights reserved.
//

// MARK:- Protocol
protocol ProfileCoordinatorOutput: class {
    var onBackAction: (()->())? { get set }
    var onCompleteAuth: (()->())? { get set }
}

final class ProfileCoordinator: BaseCoordinator, ProfileCoordinatorOutput {
    internal var onCompleteAuth: (() -> ())?
    internal var onBackAction: (() -> ())?

    
    private let factory: ProfileModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(router: Router, factory: ProfileModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        showProfile()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showProfile() {
        let profileOutput = factory.makeProfileOutput()
        profileOutput.onBack = { [weak self] in
            BusinessModel.shared.usr.clear()
            self?.onBackAction?()
        }

        router.setRootModule(profileOutput)
    }
}

