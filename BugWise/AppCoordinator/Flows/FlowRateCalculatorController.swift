//
//  FlowRateCalculatorController.swift
//  BugWise
//
//  Created by olbu on 6/28/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxSwift
import RxCocoa

class FlowRateCalculatorController: BaseViewController {
    
    private let footerModel = CalculatorFooterModel(title: "Formula for IV Flow Rate", formula: "(volume x drop factor)/time", notes: nil)
    
    
    @IBOutlet weak var volumeField: CalculatorField!
    @IBOutlet weak var timeField: CalculatorField!
    @IBOutlet weak var dropFactorField: CalculatorField!
    @IBOutlet weak var resultField: CalculatorField!
    
    @IBOutlet weak var footer: CalculatorFooter!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        footer.config(with: footerModel)
        
        resultField.inputColor = CommonAppearance.strongRedColor
        
        volumeField
            .valueTextField
            .rx
            .text
            .subscribe{ _ in
                self.updateResult()
            }.addDisposableTo(disposeBag)
        
        timeField
            .valueTextField
            .rx
            .text
            .subscribe{ _ in
                self.updateResult()
            }.addDisposableTo(disposeBag)
        
        dropFactorField
            .valueTextField
            .rx
            .text
            .subscribe{ _ in
                self.updateResult()
            }.addDisposableTo(disposeBag)
        
    }
    
    private func updateResult() {
        guard let volume = Double(volumeField.valueTextField.text!) else {
            resultField.valueTextField.text = nil
            return
        }
        
        guard let time = Double(timeField.valueTextField.text!) else {
            resultField.valueTextField.text = nil
            return
        }
        
        guard let dropFactor = Double(dropFactorField.valueTextField.text!) else {
            resultField.valueTextField.text = nil
            return
        }
        
        
        let result = volume * dropFactor / time
        
        resultField.valueTextField.text = String(format: "%.1f", Double(floor(1000*result)/1000))
    }
}


extension FlowRateCalculatorController {
    static func controller() -> FlowRateCalculatorController {
        let controller = FlowRateCalculatorController.controllerFromStoryboard(.doseCalculator)
        controller.title = CalculatorTypes.flowRate.rawValue
        
        return controller
    }
}
