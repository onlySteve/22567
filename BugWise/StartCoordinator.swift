//
//  StartCoordinator.swift
//  BugWise
//
//  Created by olbu on 6/2/17.
//  Copyright © 2017 olbu. All rights reserved.
//

// MARK:- Protocol

protocol StartCoordinatorOutput: class {
    var finishFlow: StartFlowSelect? { get set }
}

// MARK:- Implementation

final class StartCoordinator: BaseCoordinator, StartCoordinatorOutput {
    
    var finishFlow: StartFlowSelect?
    
    
    private let factory: StartModuleFactory
    private let router: Router
    
    init(router: Router,
         factory: StartModuleFactory) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showStart()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showStart() {
        let startOutput = factory.makeStartOutput()
        startOutput.onFlowSelect = { [weak self] in
            self?.finishFlow?($0)
        }
        
        router.setRootModule(startOutput)
    }

}
