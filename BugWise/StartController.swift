//
//  StarterViewController.swift
//  BugWise
//
//  Created by olbu on 5/30/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

final class StartViewController: UIViewController, StartView {

    // MARK:- Controller handler
    var onFlowSelect: (StartFlowSelect)?
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK:- Actions
    @IBAction func patientButtonAction(_ sender: UIButton) {
        let businessModel = BusinessModel.shared
        businessModel.applicationState = .patient
        let user = businessModel.usr
        user.pinCode.value = "002E9878EBFEB64E"
        user.userName.value = ""
        user.sureName.value = ""
        user.phone.value = ""
        user.mail.value = ""
        
        showDisclaimerAlert(agreeAction: {
            showHud()
            BusinessModel.shared.performLogIn(onSuccess: {
                showHud(message:"Success", completion: { [weak self] in
                    self?.onFlowSelect?(.patient)
                })
            }, onFail: { (errorDesc) in
                showHud(success: false, message: errorDesc ?? " Fail ", completion: {
                })
            })
        })
    }
    
    @IBAction func healthCareProviderAction(_ sender: UIButton) {
        BusinessModel.shared.applicationState = .provider
        onFlowSelect?(.healthCareProvider)
    }
}
