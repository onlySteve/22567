//
//  OfflineDataDetailedController.swift
//  BugWise
//
//  Created by olbu on 6/17/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RxSwift
import RxCocoa
import RxGesture
import ObjectMapper
import RealmSwift

class OfflineDataDetailedController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var onTradeItemSelect: ((List<TradeEntity>) -> ())?
    var onAssociatedItemSelect: ((SearchModuleItem) -> ())?
    var onSurveillanceDataSelect: ((SearchModuleItem?) -> ())?
    var onFavoriteItemSelect: ((Bool)->())?
    var initialFavStatus: Bool = false
    
    var entity: BaseEntity?
    
    var dataSource = Array<OfflineSectionModel>()
    let disposeBag = DisposeBag()
    
    private var associatedSetupDone: Bool = false
    
    override func viewDidLoad() {
        guard let entity = entity else {
            return
        }
        
        if entity.isKind(of: AntibioticEntity.self) {
            showDisclaimerAlert(preview: true)
        }
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            
            let section = self?.dataSource[indexPath.section]
            if section?.items.count == 1 { return }
            
            self?.dataSource[indexPath.section].selected = !(section?.selected)!
            
            self?.tableView.reloadSections([indexPath.section], with: .automatic )
            
        }).addDisposableTo(disposeBag)
        
        dataSource = config(with: entity)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarActions()
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].selected ? 2 : 1
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = dataSource[indexPath.section].items[indexPath.row]
        
        if item.isKind(of: ReturnHeaderModel.self) {
            let cell: ReturnHeaderCell = tableView.dequeueReusableCell(withIdentifier: ReturnHeaderCell.nameOfClass) as! ReturnHeaderCell
            cell.config(with: item as! ReturnHeaderModel)
            
            return cell
        }
        
        if item.isKind(of: ReturnHeaderButtonModel.self) {
            let cell: ReturnHeaderButtonCell = tableView.dequeueReusableCell(withIdentifier: ReturnHeaderButtonCell.nameOfClass) as! ReturnHeaderButtonCell
            cell.config(with: item as! ReturnHeaderButtonModel)
            
            cell.actionButton
                .rx
                .tap
                .subscribe{ [weak self] _ in
                    if let searchItem = EntitiesManager.shared.searcItem(id: (self?.entity?.id)!) {
                        self?.onSurveillanceDataSelect?(searchItem)
                    }
                    
                    if let searchItem = EntitiesManager.shared.searcItem(id: (self?.entity?.parentID)!) {
                        self?.onSurveillanceDataSelect?(searchItem)
                    }
                }.addDisposableTo(disposeBag)
            
            return cell
        }
        
        
        if item.isKind(of: ReturnSectionHeaderModel.self) {
            let cell: ReturnSectionHeaderCell = tableView.dequeueReusableCell(withIdentifier: ReturnSectionHeaderCell.nameOfClass) as! ReturnSectionHeaderCell
            cell.config(with: item as! ReturnSectionHeaderModel, selected: dataSource[indexPath.section].selected)
            
            return cell
        }
        
        if item.isKind(of: ReturnDetailedTextModel.self) {
            let cell: ReturnSectionDetailedTextCell = tableView.dequeueReusableCell(withIdentifier: ReturnSectionDetailedTextCell.nameOfClass) as! ReturnSectionDetailedTextCell
            cell.config(with: item as! ReturnDetailedTextModel)
            
            return cell
        }
        
        if item.isKind(of: ReturnActionsModel.self) {
            let actionsModel = item as! ReturnActionsModel
            
            
            let cell: ReturnSectionActionsTableViewCell = tableView.dequeueReusableCell(withIdentifier: ReturnSectionActionsTableViewCell.nameOfClass) as! ReturnSectionActionsTableViewCell
            
            if associatedSetupDone {
                return cell
            }
            
            cell.tableViewHeight.constant = ReturnSectionActionsTableViewCell.cellHeight * CGFloat(actionsModel.items.count)
            
            let itemsObservable = Observable.just(actionsModel.items.sorted(by: {$0.orderNumber < $1.orderNumber}))
            
            itemsObservable
                .bindTo(cell.tableView.rx.items(cellIdentifier: ReturnSectionActionCell.nameOfClass, cellType: ReturnSectionActionCell.self)) { index, model, cell in
                    cell.config(with: model)
                                        
                    if BusinessModel.shared.applicationState == .patient {
                        cell.labelTrailingToSuperview.constant = 8
                        return
                    }

                    guard let searchItem = EntitiesManager.shared.searcItem(id: model.id) else {
                        
                        cell.labelTrailingToSuperview.constant = 8
                        return
                    }
                    
                    if searchItem.typeEnum != .condition {
                        cell.button.isHidden = false
                    }
                    
                    cell.button
                        .rx
                        .tap
                        .subscribe { [weak self] _ in
                            self?.onSurveillanceDataSelect?(searchItem)
                        }.addDisposableTo(self.disposeBag)
                    
                }.addDisposableTo(disposeBag)
            
            cell.tableView
                .rx
                .modelSelected(AssociatedEntity.self).subscribe(onNext: { [weak self] (associatedEntity) in
                    
                    guard let searchItem = EntitiesManager.shared.searcItem(id: associatedEntity.id) else {
                        return
                    }
                    
                    self?.onAssociatedItemSelect?(searchItem)
                }).addDisposableTo(disposeBag)

            associatedSetupDone = true
            
            cell.tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Private
    
    private func setupNavBarActions() {
        
        let shareBarButton = UIBarButtonItem(image: UIImage(named: "share"),
                                             style: .plain,
                                             actionHandler: { [weak self] in
                                                
                                                // text to share
                                                let text = "Hi, I thought you may find the Bug Wise application clinically useful in promoting antimicrobial stewardship. The application is freely available in your App store"
                                                
                                                // set up activity view controller
                                                let textToShare = [ text ]
                                                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                                                activityViewController.popoverPresentationController?.sourceView = self?.view // so that iPads won't crash
                                                
                                                // present the view controller
                                                self?.present(activityViewController, animated: true, completion: nil)
        })
        
        
        let favoriteButton = UIButton(type: .custom)
        
        favoriteButton.setImage(#imageLiteral(resourceName: "fav_s"), for: .selected)
        favoriteButton.setImage(#imageLiteral(resourceName: "nav_fav"), for: .normal)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        favoriteButton.addTarget(self, action: #selector(self.favoriteButtonAction(_:)), for: .touchUpInside)
        
        
        let favoriteBarButton = UIBarButtonItem(customView: favoriteButton)
        
        favoriteButton.isSelected = initialFavStatus
        
        navigationItem.rightBarButtonItems = [shareBarButton!, favoriteBarButton]
    }
    
    @objc private func favoriteButtonAction(_ button: UIButton) {
        button.isSelected = !button.isSelected
        initialFavStatus = button.isSelected
        
        onFavoriteItemSelect?(button.isSelected)
    }
    
    private func config(with entity: BaseEntity) -> (Array<OfflineSectionModel>) {
        
        var resultArray = Array<OfflineSectionModel>()
        
        if entity.isKind(of: MicrobeEntity.self) {
            let microbeEntity = entity as! MicrobeEntity
            
            let headerSection = OfflineSectionModel(items: [ReturnHeaderModel(type: .microbes, title: microbeEntity.title, imagePath: microbeEntity.imagePath)], selected: false)

            resultArray.append(headerSection)
            
            if BusinessModel.shared.applicationState == .provider {
                let headerButtonSection = OfflineSectionModel(items: [ReturnHeaderButtonModel(action: {
                    
                })], selected: false)
                
                resultArray.append(headerButtonSection)
            }
            
            
            if let section = sectionModel(type: .description, descText: microbeEntity.desc) {
                resultArray.append(section)
            }
            
            let associated = microbeEntity.associatedInfections.toArray()
            
            if associated.count > 0  {
                let headerModel = ReturnSectionHeaderModel(type: .associatedInfections)
                let cellModel = ReturnActionsModel(items: associated)
                
                let offlineSectionModel = OfflineSectionModel(items: [headerModel, cellModel], selected: false)
                resultArray.append(offlineSectionModel)
                
            }
            
            if BusinessModel.shared.applicationState == .provider {
                if let section = sectionModel(type: .treatment, descText: microbeEntity.treatment) {
                    resultArray.append(section)
                }
                
                if let section = sectionModel(type: .references, descText: microbeEntity.references) {
                    resultArray.append(section)
                }
            }
        }
        
        if entity.isKind(of: AntibioticEntity.self) {
            let antibioticEntity = entity as! AntibioticEntity
            
            if BusinessModel.shared.applicationState == .patient {
                
                let tradeAction: voidBlock = { [weak self] in
                    self?.onTradeItemSelect?(antibioticEntity.trades)
                }
                
                let headerSection = OfflineSectionModel(items: [ReturnHeaderModel(type: .antibiotics, title: antibioticEntity.heading, subtitle: "The information below is for formulations taken by mouth. Please consult your healthcare provider for treatment advice", tradeAction:tradeAction)], selected: false)
                
                resultArray.append(headerSection)
                
                let headerButtonSection = OfflineSectionModel(items: [ReturnHeaderButtonModel(action: {
                    
                })], selected: false)
                
                resultArray.append(headerButtonSection)
                
                if let section = sectionModel(type: .availableAs, descText: antibioticEntity.strength) {
                    resultArray.append(section)
                }
                
                if let section = sectionModel(type: .storageInstructions, descText: antibioticEntity.storage) {
                    resultArray.append(section)
                }
                
                if let section = sectionModel(type: .uses, descText: antibioticEntity.indication) {
                    resultArray.append(section)
                }
                
                if let section = sectionModel(type: .inadvisibleUses, descText: antibioticEntity.contraindication) {
                    resultArray.append(section)
                }
                
                if let section = sectionModel(type: .sideEffects, descText: antibioticEntity.sideEffect) {
                    resultArray.append(section)
                }
                
            } else {
                
                let tradeAction: voidBlock = { [weak self] in
                    self?.onTradeItemSelect?(antibioticEntity.trades)
                }
                
                let headerSection = OfflineSectionModel(items: [ReturnHeaderModel(type: .antibiotics, title: antibioticEntity.heading, subtitle: "Bug Wise provides drug references. For guidelines see Infections (where available)", tradeAction:tradeAction)], selected: false)
                
                resultArray.append(headerSection)
                
                let headerButtonSection = OfflineSectionModel(items: [ReturnHeaderButtonModel(action: {
                    
                })], selected: false)
                
                resultArray.append(headerButtonSection)
                
                if let section = sectionModel(type: .classType, descText: antibioticEntity.classType) {
                    resultArray.append(section)
                }
                
                if let section = sectionModel(type: .strength, descText: antibioticEntity.strength) {
                    resultArray.append(section)
                }
                
                if let section = sectionModel(type: .dose, descText: antibioticEntity.dose) {
                    resultArray.append(section)
                }
                
                if let section = sectionModel(type: .indication, descText: antibioticEntity.indication) {
                    resultArray.append(section)
                }
                
                if let section = sectionModel(type: .methodOfAdministration, descText: antibioticEntity.administration) {
                    resultArray.append(section)
                }
            }
        }
        
        if entity.isKind(of: InfectionEntity.self) {
            let infectionEntity = entity as! InfectionEntity
            
            let headerSection = OfflineSectionModel(items: [ReturnHeaderModel(type: .infections, title: infectionEntity.title, imagePath: infectionEntity.imagePath)], selected: false)
            
            resultArray.append(headerSection)
            
            
            if let section = sectionModel(type: .description, descText: infectionEntity.desc) {
                resultArray.append(section)
            }
            
            if BusinessModel.shared.applicationState == .provider {
                if let section = sectionModel(type: .diagnosis, descText: infectionEntity.diagnosis) {
                    resultArray.append(section)
                }
            }
            
            let associated = infectionEntity.associatedMicrobes.toArray()
            
            if associated.count > 0  {
                let headerModel = ReturnSectionHeaderModel(type: .associatedMicrobes)
                let cellModel = ReturnActionsModel(items: associated)
                
                let offlineSectionModel = OfflineSectionModel(items: [headerModel, cellModel], selected: false)
                resultArray.append(offlineSectionModel)
            }
            
            if let section = sectionModel(type: .treatment, descText: String(format: "%@\n%@", infectionEntity.firstLine ?? "", infectionEntity.secondLine ?? "")) {
                resultArray.append(section)
            }
            
            if BusinessModel.shared.applicationState == .provider {
                if let section = sectionModel(type: .references, descText: infectionEntity.references) {
                    resultArray.append(section)
                }
            }
        }
        
        return resultArray
    }
    
    
    private func sectionModel(type: RetrunSectionHeaderTypeEnum, descText: String?) -> OfflineSectionModel? {
        guard let descriptionText = descText, description.characters.count > 1 else {
            return nil
        }
        
        let headerModel = ReturnSectionHeaderModel(type: type)
        let cellModel = ReturnDetailedTextModel(title: descriptionText)
        
        let offlineSectionModel = OfflineSectionModel(items: [headerModel, cellModel], selected: false)
        
        return offlineSectionModel
    }
    
}
