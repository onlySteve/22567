//
//  ApplicationModel.swift
//  BugWise
//
//  Created by olbu on 5/31/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import RxSwift

// MARK:- Application State

enum ApplicationState {
    case NotSignedIn
    case HealthCareProvider
    case Patient
}

// MARK:- Protocol

protocol ApplicationModel {
    var applicationState: ApplicationState { get }
    var application: UIApplication { get }
}

// MARK:- Implementation

class ApplicationModelImpl: ApplicationModel {
    private let mApplicationState = Variable<ApplicationState>(.NotSignedIn)
    var applicationState: ApplicationState {
        return mApplicationState.value
    }
    
    
    let application: UIApplication
    
    init(application: UIApplication) {
        self.application = application
    }
}

// MARK:- Factory

class ApplicationModelFactory {
    static func defaultApplicationModelWithApplication(application: UIApplication) -> ApplicationModel {
        return ApplicationModelImpl(
            application: application
        )
    }
}

// MARK:- Service Locator

class ApplicationModelLocator {
    private static var applicationModel: ApplicationModel?
    
    static func populateWithApplicationModel(applicationModel: ApplicationModel) {
        ApplicationModelLocator.applicationModel = applicationModel
    }
    
    static var sharedModel: ApplicationModel {
        return ApplicationModelLocator.applicationModel!
    }
}

