//
//  SurveillanceDataController.swift
//  BugWise
//
//  Created by olbu on 6/30/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift
import RxGesture

fileprivate typealias BindBlock = (String) -> Void

class SurveillanceDataController: BaseViewController {

    var microbeEntity: SearchModuleItem? = nil
    var antibioticEntity: SearchModuleItem? = nil
    
    @IBOutlet weak var microbeClearButton: UIButton!
    @IBOutlet weak var antibioticClearButton: UIButton!
    
    @IBOutlet weak var microbeField: ProfileTextField!
    @IBOutlet weak var antimicrobialField: ProfileTextField!
    @IBOutlet weak var sectorField: ProfileTextField!
    @IBOutlet weak var locationField: ProfileTextField!
    
    @IBOutlet weak var searchButton: BaseButton!
    
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    private let disposeBag = DisposeBag()
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Appstore hotFix for iPhone 4 layout
        let viewHeight = view.frame.size.height - 20 - 40 - 39
        
        if viewHeight <= 381 {
            contentHeightConstraint.constant = 450
        } else {
            scrollView.isScrollEnabled = false
            contentHeightConstraint.constant = viewHeight
        }
        
        bindUI()
    }
    
    private func bindUI() {
        
        microbeField.textField.text = microbeEntity?.title
        antimicrobialField.textField.text = antibioticEntity?.title
        
        let currentSectorType = BusinessModel.shared.usr.sector.value
        
        sectorField.textField.text = (currentSectorType == .both ? .privateType : currentSectorType).rawValue
        sectorField.textField.isUserInteractionEnabled = false
        
        locationField.textField.text = BusinessModel.shared.usr.location.value.rawValue
        locationField.textField.isUserInteractionEnabled = false
        
        updateSearchButton()
        
        microbeClearButton
            .rx
            .tap
            .subscribe { [weak self] _ in
                self?.microbeEntity = nil
                self?.microbeField.textField.text = nil
                self?.updateSearchButton()
            }.addDisposableTo(disposeBag)
        
        antibioticClearButton
            .rx
            .tap
            .subscribe { [weak self] _ in
                self?.antibioticEntity = nil
                self?.antimicrobialField.textField.text = nil
                self?.updateSearchButton()
            }.addDisposableTo(disposeBag)
        
        bindSearch(field: antimicrobialField, searchType: .drug) { [weak self] (entity) in
            self?.antibioticEntity = entity
            self?.updateSearchButton()
        }
        
        bindSearch(field: microbeField, searchType: .microbe) { [weak self] (entity) in
            self?.microbeEntity = entity
            self?.updateSearchButton()
        }
        
        bindProfileTextField(textField: sectorField, array: Sector.surveillanceArray.map{ $0.rawValue }, actionSheetTitle: "Select Sector type")
        
        bindProfileTextField(textField: locationField, array: Location.allValues.map{ $0.rawValue }, actionSheetTitle: "Select Location")

        searchButton
            .rx
            .tap
            .subscribe { [weak self] _ in
                
                if (BusinessModel.shared.notReachableNetwork) {
                    showNetworkReachabilityAlert()
                    return
                }
                
                showHud()
                
                let requestData = SurveillanceRequestEntity(microbe: self?.microbeEntity, antibiotic: self?.antibioticEntity, sector: (self?.sectorField.textField.text)!, location: (self?.locationField.textField.text)!)
                
                EntitiesManager.shared.surveillanceData(requestData, onSuccess: { (resultArray) in
                    hideHud()
                    
                    let controller = SurveillanceDetailController.controller()
                    controller.items = resultArray
                    controller.title = "Search Result"
                    controller.requestEntity = requestData
                    
                    self?.navigationController?.pushViewController(controller, animated: true)
                }, onFail: {
                    showHud(success: false, message: " Fail ", completion: nil)
                })
                
            }.addDisposableTo(disposeBag)
    }
    
    private func isTextFieldsFilledUp() -> Bool {
        return ((antimicrobialField.textField.text?.characters.count)! > 0 || (microbeField.textField.text?.characters.count)! > 0) && (sectorField.textField.text?.characters.count)! > 0 && (locationField.textField.text?.characters.count)! > 0
    }
    
    private func updateSearchButton() {
    
        if isTextFieldsFilledUp() {
            searchButton.isUserInteractionEnabled = true
            searchButton.setBackgroundColor(color: CommonAppearance.redColor,
                                            forState: .normal)
            searchButton.setBackgroundColor(color: CommonAppearance.redColor.withAlphaComponent(0.7),
                                            forState: .highlighted)
        } else {
            searchButton.isUserInteractionEnabled = false
            searchButton.setBackgroundColor(color: CommonAppearance.greyColor,
                                            forState: .normal)
        }
    }
    
    private func bindSearch(field: ProfileTextField, searchType: ModuleSearchType, completion: @escaping (SearchModuleItem?) -> Void) {
        
        field.textField.isUserInteractionEnabled = false
        
        field
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                
                if (BusinessModel.shared.notReachableNetwork) {
                    showNetworkReachabilityAlert()
                    return
                }
                
                guard let items = EntitiesManager.shared.searcItemsOfflineData(type: searchType) else {
                    completion(nil)
                    return
                }
                
                let search = SearchController.controller()
                
                search.isModalPresentation = true
                
                search.onSearchItemSelect = { searchItem in
                    field.textField.text = searchItem.title
                    completion(searchItem)
                    search.dismiss(animated: true, completion: nil)
                }
                
                search.onSearchBarCancelSelect = {
                    search.dismiss(animated: true, completion: nil)
                }
                
                search.items = items
                
                self?.present(search, animated: true, completion: {
                    search.searchBar.becomeFirstResponder()
                    })
                
            }).addDisposableTo(disposeBag)
        
    }
    
    
    private func bindProfileTextField(textField: ProfileTextField, array: [String] , actionSheetTitle: String? = nil) {
        
        textField
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe{ [weak self] _ in
                
                var actionsArray = array.map({ str in
                    UIAlertAction(title: str, style: .default) { actionButton in
                        textField.textField.text = str
                    }
                })
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
                
                actionsArray.append(cancelButton)
                
                let actionSheet = alert(withTitle: actionSheetTitle ?? "", actions: actionsArray, style: .actionSheet)
                
                self?.present(actionSheet, animated: true, completion: nil)
                
            }.addDisposableTo(disposeBag)
    }
}

extension SurveillanceDataController {
    static func controller(antibiotic: SearchModuleItem? = nil, microbe: SearchModuleItem? = nil) -> SurveillanceDataController {
        
        let controller = SurveillanceDataController.controllerFromStoryboard(.surveillance)
        controller.title = MenuType.surveillanceData.title
        controller.antibioticEntity = antibiotic
        controller.microbeEntity = microbe
        
        return controller
    }
}
