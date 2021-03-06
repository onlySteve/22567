
import RealmSwift

final class HomeCoordinator: BaseCoordinator {
    
    private let factory: HomeModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(router: Router, factory: HomeModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        showHomeScreen()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showHomeScreen() {
        
        let homeOutput = factory.makeHomeOutput()
        homeOutput.onMenuItemSelect = { menuItem in
            switch menuItem {
            case .generalAlerts:
                self.showAlerts()
                break
            case .infections:
                self.showSearch(.condition, title: menuItem.title)
                break
            case .antibiotics:
                self.showOnlineSearch(.drug, title: menuItem.title)
                break
            case .microbes:
                self.showSearch(.microbe, title: menuItem.title)
            case .doseCalculators:
                self.showCalculators()
            case .surveillanceData:
                self.showSurveilanceData()
            case .interactions:
                self.showInteractions()
            case .duplications:
                self.showDuplications()
            }
        }
        
        homeOutput.onSearchItemSelect = { searchItem in
            switch searchItem.typeEnum {
            case .condition:
                self.showOfflineDetailed(searchItem: searchItem)
                break
            case .drug:
                
                if (BusinessModel.shared.notReachableNetwork) {
                    showNetworkReachabilityAlert()
                    break
                }
                
                showHud()
                EntitiesManager.shared.antibiotic(id: searchItem.id, onSucces: { (entity) in
                    hideHud()
                    self.showOfflineDetailed(searchItem: searchItem)
                }, onFail: {
                    showHud(success: false, time: 0.3, message: "Fail", completion: nil)
                })
                break
            case .microbe:
                self.showOfflineDetailed(searchItem: searchItem)
                break
            }
        }

        homeOutput.onMedicineReminderSelect = {
            self.showMedicineReminder()
        }
        
        router.setRootModule(homeOutput)
    }
    
    private func showCalculators () {
        router.push(CalculatorsController.controller())
    }
    
    private func showAlerts() {
        router.push(AlertsController.controller())
    }
    
    private func showSearch(_ type: ModuleSearchType, title: String) {
        
        guard let items = EntitiesManager.shared.searcItemsOfflineData(type: type) else { return }
        
        let search = SearchController.controller()
        
        search.onSearchItemSelect = { searchItem in
            switch searchItem.typeEnum {
            case .condition:
                self.showOfflineDetailed(searchItem: searchItem)
                break
            case .drug:
                
                if (BusinessModel.shared.notReachableNetwork) {
                    showNetworkReachabilityAlert()
                    break
                }
                
                showHud()
                EntitiesManager.shared.antibiotic(id: searchItem.id, onSucces: { (entity) in
                    hideHud()
                    self.showOfflineDetailed(searchItem: searchItem)
                }, onFail: {
                    showHud(success: false, time: 0.3, message: "Fail", completion: nil)
                })
                break
            case .microbe:
                self.showOfflineDetailed(searchItem: searchItem)
                break
            }
        }
        search.title = title
        search.items = items
        router.push(search)
    }
    
    func showOnlineSearch(_ type: ModuleSearchType, title: String) {
        
        if (BusinessModel.shared.notReachableNetwork) {
            showNetworkReachabilityAlert()
            return
        }
        
        let search = SearchOnlinceController.controller()
        
        search.needToShowOfflineData = true
        
        search.onSearchItemSelect = { searchItem in
            
            EntitiesManager.shared.saveSearchModuleItem(searchItem)
            
            switch searchItem.typeEnum {
            case .condition:
                self.showOfflineDetailed(searchItem: searchItem)
                break
            case .drug:
                
                if (BusinessModel.shared.notReachableNetwork) {
                    showNetworkReachabilityAlert()
                    break
                }
                
                showHud()
                EntitiesManager.shared.antibiotic(id: searchItem.id, onSucces: { (entity) in
                    hideHud()
                    self.showOfflineDetailed(searchItem: searchItem)
                }, onFail: {
                    showHud(success: false, time: 0.3, message: "Fail", completion: nil)
                })
                break
            case .microbe:
                self.showOfflineDetailed(searchItem: searchItem)
                break
            }
        }
        
        search.title = title
        
        router.push(search)
    }
    
    func showDetailedFromFavourite(searchItem: SearchModuleItem?) {
        NotificationCenter.default.post(name: showHomeTabNotificationName, object: nil)
        
        router.popToRootModule(animated: false)
        showOfflineDetailed(searchItem: searchItem)
    }
    
    private func showOfflineDetailed(searchItem: SearchModuleItem?) {
        
        guard let searchItem = searchItem else { return }
        
        var entity: BaseEntity?
        
        switch searchItem.typeEnum {
        case .condition:
            entity = EntitiesManager.shared.infection(id: searchItem.id)
            break
        case .drug:
            entity = EntitiesManager.shared.antibioticCached(id: searchItem.id)
            break
        case .microbe:
            entity = EntitiesManager.shared.microbe(id: searchItem.id)
            break
        }
        
        if entity == nil { return }
        
        let type = searchItem.typeEnum
        
        let controller = OfflineDataDetailedController.controllerFromStoryboard(.search)
        
        controller.entity = entity
        
        controller.onTradeItemSelect = { [weak self] (trades) in
            self?.showTrades(trades)
        }
        
        controller.onAssociatedItemSelect = { [weak self] (associatedItem) in
            switch type {
            case .drug:
                break
            default:
                self?.showOfflineDetailed(searchItem: associatedItem)
                break
            }
        }
        
        controller.onSurveillanceDataSelect = { [weak self] (surveillanceEntity) in
            
            if BusinessModel.shared.applicationState == .patient {
                self?.showMedicineReminder(antibiotic:  surveillanceEntity?.typeEnum == .drug ? surveillanceEntity : nil)
            } else {
                self?.showSurveilanceData(microbe: surveillanceEntity?.typeEnum == .microbe ? surveillanceEntity : nil, antibiotic: surveillanceEntity?.typeEnum == .drug ? surveillanceEntity : nil)
            }
        }
        
        controller.initialFavStatus = searchItem.isFavorite
        controller.onFavoriteItemSelect = { EntitiesManager.shared.updateEntity(searchItem, favStatus: $0) }
        
        self.router.push(controller, animated: true)
    }
    
    
    private func showTrades(_ trades:List<TradeEntity>) {
        router.push(TradesController.controller(items: trades))
    }
    
    private func showSurveilanceData(microbe: SearchModuleItem? = nil, antibiotic: SearchModuleItem? = nil) {
        router.push(SurveillanceDataController.controller(antibiotic: antibiotic, microbe: microbe))
    }
    
    private func showInteractions() {
        router.push(InteractionsController.interactionsController())
    }
    
    private func showDuplications() {
        router.push(InteractionsController.duplicationsController())
    }
    
    private func showMedicineReminder(antibiotic: SearchModuleItem? = nil) {
        router.push(ReminderViewController.controller(antibiotic:antibiotic))
    }
}
