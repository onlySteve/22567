//
//  EntitiesManager.swift
//  BugWise
//
//  Created by olbu on 6/17/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import RealmSwift
import ObjectMapper
import Moya
import RxSwift
import RxRealm
import RxCocoa
import Moya_ObjectMapper
import RxOptional


final class EntitiesManager {

    // MARK:- Private properties
    private let disposeBag = DisposeBag()
    
    let endpointClosure = { (target: API) -> Endpoint<API> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        
        let headers: [String: String]?
        
        // Sign all non-authenticating requests
        switch target {
        case .authorization:
            headers = nil
        default:
            headers = ["Token": BusinessModel.shared.usr.token.value ?? ""]
        }
        
        return Endpoint<API>(
            url: target.baseURL.appendingPathComponent(target.path).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            parameters: target.parameters,
            parameterEncoding: target.parameterEncoding,
            httpHeaderFields: headers
            
        )
    }
    
    private let realm = try? Realm()
    
    private init() {
        
    }
    
    static let shared = EntitiesManager()
    
    
    //MARK:- Public
    
    //MARK:- OfflineData
    
    func offlineData(onSuccess: voidBlock?, onFail: voidBlock?) {
        
        let provider = RxMoyaProvider<API>(endpointClosure: endpointClosure)
        
        provider
            .request(.offlineContent())
            .mapJSON(failsOnEmptyData:  true)
            .subscribe{ event in
                switch event {
                case .next(let json as [String: Any]):
                    self.dropDB()
                    if let searchItems = json["searchTerms"] as? [String:[[String: Any]]],
                        let microbesJSON = json["Microbes"] as? [[String: Any]],
                        let infectionsJSON = json["Conditions"] as? [[String: Any]] {
                        
                        self.searchItemsMap(searchItems)
                        self.microbeEntitiesMap(microbesJSON)
                        self.infectionEntitiesMap(infectionsJSON)
                        
                        self.updateFavouriteStatus()
                        
                        onSuccess?()
                    } else {
                        onFail?()
                    }
                    break
                case .error(_):
                    onFail?()
                    break
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
    
    //MARK:- Alerts
    var alerts: [AlertEntity]? {
        get{
            return self.realm?.objects(AlertEntity.self).toArray()
        }
    }
    
    //MARK:- DetailedEntities
    func updateEntity(_ entity: SearchModuleItem?, favStatus: Bool) {
        
        guard let entity = entity else {
            return
        }
        
        try! realm?.write {
            entity.isFavorite = favStatus
        }
    }
    
    func infection(id: String) -> InfectionEntity? {
        return realm?.object(ofType: InfectionEntity.self, forPrimaryKey: id)
    }
    
    func microbe(id: String) -> MicrobeEntity? {
        return realm?.object(ofType: MicrobeEntity.self, forPrimaryKey: id)
    }
    
    func antibiotic(id: String, onSucces:@escaping ((AntibioticEntity?) -> Void), onFail:voidBlock?) {
        
        //Fucking ServerSide Magic
        let index = id.index(after: id.startIndex)
        let serverID = id.substring(from: index)
        
        if let entity = realm?.object(ofType: AntibioticEntity.self, forPrimaryKey: serverID) {
            onSucces(entity)
            return
        }
        
        let provider = RxMoyaProvider<API>(endpointClosure: endpointClosure)

        provider
            .request(.antibioticDetails(id: serverID))
            .mapObject(AntibioticEntity.self)
            .subscribe { event in
                switch event {
                case .next(let entity):
                    
                    entity.parentID = id
                    
                    try! self.realm?.write {
                        self.realm?.add(entity, update: true)
                    }
                    
                    onSucces(entity)
                    
                    break
                case .error(_):
                    onFail?()
                    break
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
    
    func microbeEntitiesMap(_ microbesJSON: [[String: Any]], save: Bool = true) {
        if let itemsMappedArray = Mapper<MicrobeEntity>().mapArray(JSONArray: microbesJSON), save {
            try! realm?.write {
                realm?.add(itemsMappedArray, update: true)
            }
        }
    }
    
    func infectionEntitiesMap(_ infectionsJSON: [[String: Any]], save: Bool = true) {
        if let itemsMappedArray = Mapper<InfectionEntity>().mapArray(JSONArray: infectionsJSON), save {
            try! realm?.write {
                realm?.add(itemsMappedArray, update: true)
            }
        }
    }
    
    func alertEntitiesMap(_ alertsJSON: [[String : Any]], save: Bool = true) {
        if let mappedAlerts = Mapper<AlertEntity>().mapArray(JSONArray: alertsJSON), save {
            
            try! realm?.write {
                realm?.add(mappedAlerts, update: true)
            }
        }
    }
    
    func items<T>(type: T.Type) -> Array<Any>? {
        return realm?.objects(type as! Object.Type).toArray()
    }
    
    //MARK:- SearchItems
    func searcItems(type: ModuleSearchType? = nil) -> [SearchModuleItem]? {
        if (type != nil) {
            return realm?.objects(SearchModuleItem.self).toArray().filter{ $0.typeEnum == type }
        } else {
            return realm?.objects(SearchModuleItem.self).toArray()
        }
    }
    
    func searcItem(id: String?) -> SearchModuleItem? {
        
        guard let id = id else {
            return nil
        }
        
        return realm?.object(ofType: SearchModuleItem.self, forPrimaryKey: id)
    }
    
    func searchItemsMap(_ searchItemsJSON: [String:[[String: Any]]], save: Bool = true) {
        for (key, value) in searchItemsJSON {
            if let itemsMappedArray = Mapper<SearchModuleItem>().mapArray(JSONArray: value) {
                
                itemsMappedArray.forEach({ (item) in
                    item.typeEnum = ModuleSearchType(rawValue: key)!
                })
                
                if !save {
                    return
                }
                
                try! realm?.write {
                    realm?.add(itemsMappedArray, update: true)
                }
            }
        }
    }
    
    
    //MARK:- SurveillanceData
    func surveillanceData(_ requestData: SurveillanceRequestEntity, onSuccess: @escaping ((Array<SurveillanceEntity>?) -> Void ), onFail: voidBlock?) {
        
        
        let provider = RxMoyaProvider<API>(endpointClosure: endpointClosure)
        
        provider
            .request(.surviallanceData(requestData))
            .mapArray(SurveillanceEntity.self)
            .subscribe { event in
                switch event {
                case .next(let surveillanceArray):
                        onSuccess(surveillanceArray)
                    break
                case .error(_):
                    onFail?()
                    break
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
    
    //MARK:- Interactions
    func interactionsSearch(_ searchItems:Array<String>, onSuccess: @escaping (([InteractionsEntity]?) -> Void ), onFail: voidBlock?) {
    
        let provider = RxMoyaProvider<API>(endpointClosure: endpointClosure)
        
        provider
            .request(.interactions(values: searchItems))
            .mapJSON()
            .subscribe{
                event in
                switch event {
                case .next(let json as Dictionary<String,Any>):
                    
                    guard let jsonArray = json["DATA"] as! Array<Dictionary<String, Any>>? else {
                        onSuccess(nil)
                        return
                    }
                    
                    if let itemsMappedArray = Mapper<InteractionsEntity>().mapArray(JSONArray:  jsonArray) {
                        onSuccess(itemsMappedArray)
                        return
                    }
                    
                    onSuccess(nil)
                    
                    break
                case .error(let error):
                    print(error.localizedDescription)
                    onFail?()
                    break
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
    
    //MARK:- Duplications
    func duplicationsSearch(_ searchItems:Array<String>, onSuccess: @escaping ((DuplicationsEntity?) -> Void ), onFail: voidBlock?) {
        
        let provider = RxMoyaProvider<API>(endpointClosure: endpointClosure)
        
        provider
            .request(.duplications(values: searchItems))
            .mapObject(DuplicationsEntity.self)
            .debug()
            .subscribe{
                event in
                switch event {
                case .next(let duplicationsEntity):
                    onSuccess(duplicationsEntity)
                    break
                case .error(let error):
                    onFail?()
                    break
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
    
    func dropDB() {
        UserDefaults.standard.set(searcItems()?.filter{$0.isFavorite}.map{ $0.id }, forKey: String(format: "Favorites %@", BusinessModel.shared.usr.mail.value ?? ""))
        
        try! realm?.write {
            realm?.deleteAll()
        }
    }
    
    private func updateFavouriteStatus() {
    
        guard let favList = UserDefaults.standard.value(forKey: String(format: "Favorites %@", BusinessModel.shared.usr.mail.value ?? "")) as? Array<String> else {
            return
        }
    
        searcItems()?.forEach({ [weak self] (item) in
            if favList.contains(item.id) {
                self?.updateEntity(item, favStatus: true)
            }
        })
    }
}


