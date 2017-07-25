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
        onFlowSelect?(.patient)
    }
    
    @IBAction func healthCareProviderAction(_ sender: UIButton) {
        onFlowSelect?(.healthCareProvider)
    }
}
