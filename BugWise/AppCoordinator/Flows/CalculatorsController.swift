//
//  CalculatorsController.swift
//  BugWise
//
//  Created by olbu on 6/27/17.
//  Copyright © 2017 olbu. All rights reserved.
//

//
//  AlertsController.swift
//  BugWise
//
//  Created by olbu on 6/10/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

enum CalculatorTypes: String {
    case creatinine = "Creatinine Clearance Estimate by Cockcroft-Gault Equation"
    case flowRate = "IV Flow Rate"
    case paediatric = "Paediatric dosing"
    
    static let allItems = [creatinine, flowRate, paediatric]
}

class CalculatorsController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        tableView.tableFooterView = UIView()
        setupHeader()
        bindUI()
    }
    
    private func setupHeader() {
        
        let headerView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:CommonConstants.headerHeight))
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "dose_w"))
        
        
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.height * 2, height: imageView.frame.height * 2))
        bgView.backgroundColor = CommonAppearance.yellowToOrangeColor
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = bgView.frame.height/2
        
        bgView.addSubview(imageView)
        
        headerView.addSubview(bgView)
        
        imageView.snp.makeConstraints({ (make) -> Void in
            make.center.equalToSuperview()
        })
        
        bgView.snp.makeConstraints({ (make) -> Void in
            make.center.equalToSuperview()
            make.height.equalTo(bgView.frame.height)
            make.width.equalTo(bgView.frame.width)
        })
        
        tableView.tableHeaderView = headerView
    }

    private func bindUI() {
        
        let calculatorItems = Observable.just(CalculatorTypes.allItems)
        
        calculatorItems
            .bindTo(tableView.rx.items(cellIdentifier: "cellID")) { index, item, cell in
                cell.textLabel?.text = item.rawValue
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.font = RegularFontWithSize()
                cell.textLabel?.textColor = CommonAppearance.lightDarkColor
                
            }.addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(CalculatorTypes.self).subscribe(onNext: { [weak self] (calculatorType) in
            
            switch calculatorType {
            case .creatinine:
                self?.navigationController?.pushViewController(CreatinineCalculatorController.controller(), animated: true)
                break
            case .flowRate:
                self?.navigationController?.pushViewController(FlowRateCalculatorController.controller(), animated: true)
                break
            case .paediatric:
                self?.navigationController?.pushViewController(PaediatricCalculatorController.controller(), animated: true)
                break
            }
            
            }).addDisposableTo(disposeBag)
        
    }
    
}

extension CalculatorsController {
    static func controller() -> CalculatorsController {
        let controller = CalculatorsController.controllerFromStoryboard(.doseCalculator)
        controller.title = MenuType.doseCalculators.title
        
        return controller
    }
}
