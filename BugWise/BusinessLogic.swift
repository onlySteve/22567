//
//  BusinessLogic.swift
//  BugWise
//
//  Created by olbu on 6/5/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import RealmSwift
import Moya


typealias voidBlock = () -> ()

class BusinessModel {
    
    let usr: UserModel = UserModel()
    private let disposeBag = DisposeBag()
    
    private init() { }
    static let shared = BusinessModel()
    
    func performLogIn(onSuccess: voidBlock?, onFail: ((String?) -> ())?) {
        
        let provider = RxMoyaProvider<API>()
        
        provider
            .request(.authorization(pinCode: usr.pinCode.value!,
                               username: usr.userName.value!,
                               surename: usr.sureName.value!,
                               phone: usr.phone.value!,
                               mail: usr.mail.value!,
                               location: usr.location.value.rawValue,
                               userType: usr.userType.value.rawValue,
                               sector: usr.sector.value.rawValue,
                               inHospital: usr.workInHospital.value))
            .mapJSON(failsOnEmptyData: true)
            .subscribe { event in
                switch event {
                case .next(let json as [String: Any]):
                    if let token = json["token"] as? String {
                        self.usr.token.value = token
                    }

                    EntitiesManager.shared.alertEntitiesMap(json["news"] as! [[String : Any]])
 
                    EntitiesManager.shared.offlineData(onSuccess: {
                        self.usr.loggedIn.onNext(true)
                        onSuccess?()
                    }, onFail:  {
                        self.performLogout()
                       onFail?(nil)
                    })
                    break
                    
                case .error(let error as NSError):
                    onFail?(error.localizedDescription)
                    break
                    
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
    
    func performLogout() {
        
        EntitiesManager.shared.dropDB()
        
        usr.loggedIn.onNext(false)
    }
}
