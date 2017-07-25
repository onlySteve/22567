//
//  PaediatricCalculatorController.swift
//  BugWise
//
//  Created by olbu on 6/28/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxSwift
import RxCocoa

class PaediatricCalculatorController: BaseViewController {
    
    private let footerModel = CalculatorFooterModel(title: "Formula for Clark's Rule", formula: "Adult Dose x (weight of child in pounds/150)", notes: nil)
    
    @IBOutlet weak var weightField: CalculatorField!
    @IBOutlet weak var doseField: CalculatorField!
    @IBOutlet weak var resultField: CalculatorField!
    
    @IBOutlet weak var footer: CalculatorFooter!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        footer.config(with: footerModel)
        
        resultField.inputColor = CommonAppearance.strongRedColor
        
        weightField
            .valueTextField
            .rx
            .text
            .subscribe{ _ in
                self.updateResult()
            }.addDisposableTo(disposeBag)
        
        doseField
            .valueTextField
            .rx
            .text
            .subscribe{ _ in
                self.updateResult()
            }.addDisposableTo(disposeBag)
        
    }
    
    private func updateResult() {
        
        guard let weight = Double(weightField.valueTextField.text!) else {
            resultField.valueTextField.text = nil
            return
        }
        
        guard let dose = Double(doseField.valueTextField.text!) else {
            resultField.valueTextField.text = nil
            return
        }
        
        
        let result = dose * (weight * 2.20462 / 150)
        resultField.valueTextField.text = String(format: "%.3f", Double(floor(1000*result)/1000))
    }
}


extension PaediatricCalculatorController {
    static func controller() -> PaediatricCalculatorController {
        let controller = PaediatricCalculatorController.controllerFromStoryboard(.doseCalculator)
        controller.title = CalculatorTypes.paediatric.rawValue
        
        return controller
    }
}
