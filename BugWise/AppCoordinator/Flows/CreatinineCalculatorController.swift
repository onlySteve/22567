//
//  CreatinineCalculatorController.swift
//  BugWise
//
//  Created by olbu on 6/27/17.
//  Copyright © 2017 olbu. All rights reserved.
//


import RxSwift
import RxCocoa

class CreatinineCalculatorController: BaseViewController {
    
    @IBOutlet weak var femaleButton: UIButton!
    
    @IBOutlet weak var maleButton: UIButton!
    
    private let footerModel = CalculatorFooterModel(title: "Formula for estimated Creatinine Clearance", formula: "[[140-age] x weight]/[72xserum creatinine] multiply by 0.85(if female)", notes: "The formula is applicable if the serum creatinine is stable.")
    
    @IBOutlet weak var resultField: CalculatorField!
    @IBOutlet weak var serumCreatField: CalculatorField!
    @IBOutlet weak var weightField: CalculatorField!
    @IBOutlet weak var ageField: CalculatorField!
    @IBOutlet weak var footer: CalculatorFooter!
  
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        footer.config(with: footerModel)
        
        resultField.inputColor = CommonAppearance.strongRedColor
        
        ageField
            .valueTextField
            .rx
            .text
            .subscribe{ _ in
                self.updateResult()
            }.addDisposableTo(disposeBag)
        
        weightField
            .valueTextField
            .rx
            .text
            .subscribe{ _ in
                self.updateResult()
            }.addDisposableTo(disposeBag)
        
        serumCreatField
            .valueTextField
            .rx
            .text
            .subscribe{ _ in
                self.updateResult()
            }.addDisposableTo(disposeBag)
        
        maleButton
            .rx
            .tap
            .subscribe{ _ in
                if self.maleButton.isSelected {
                    return
                }
                
                self.maleButton.isSelected = true
                self.femaleButton.isSelected = false
                
                self.updateResult()
            }.addDisposableTo(disposeBag)
        
        femaleButton
            .rx
            .tap
            .subscribe{ _ in
                if self.femaleButton.isSelected {
                    return
                }
                
                self.femaleButton.isSelected = true
                self.maleButton.isSelected = false
                
                self.updateResult()
            }.addDisposableTo(disposeBag)
        
    }
    
    private func updateResult() {
        guard let age = Double(ageField.valueTextField.text!) else {
            resultField.valueTextField.text = nil
            return
        }
        
        guard let weight = Double(weightField.valueTextField.text!) else {
            resultField.valueTextField.text = nil
            return
        }
        
        guard let serumCreat = Double(serumCreatField.valueTextField.text!) else {
            resultField.valueTextField.text = nil
            return
        }
        
        let coof = maleButton.isSelected ? 1.0 : 0.85
        
        let result = coof * ( (140 - age) / serumCreat ) * (weight / 72)
        
        resultField.valueTextField.text = String(format: "%.3f", Double(floor(1000*result)/1000))
    }
}


extension CreatinineCalculatorController {
    static func controller() -> CreatinineCalculatorController {
        let controller = CreatinineCalculatorController.controllerFromStoryboard(.doseCalculator)
        controller.title = CalculatorTypes.creatinine.rawValue
        
        return controller
    }
}
