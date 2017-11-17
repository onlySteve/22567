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
import ReachabilitySwift

typealias voidBlock = () -> ()

enum ApplicationState: String {
    case provider = "ApplicationStateProvider"
    case patient = "ApplicationStatePatient"
    case undefined = "ApplicationStateUndefined"
}

class BusinessModel {
    
    let usr: UserModel = UserModel()
    
    var applicationState: ApplicationState {
        get{
            
            guard let state = UserDefaults.standard.string(forKey: "ApplicationState") else {
                return ApplicationState.undefined
            }
            
            guard let unwrapedState = ApplicationState(rawValue:state) else {
                return ApplicationState.undefined
            }
            
            return unwrapedState
        }
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: "ApplicationState")
            UserDefaults.standard.synchronize()
        }
    }

    
    var pushNotificationToken: String? {
        get{
            return UserDefaults.standard.string(forKey: "UsrPushNotitficationToken")
        }
        set(newToken){
            UserDefaults.standard.set(newToken, forKey: "UsrPushNotitficationToken")
            UserDefaults.standard.synchronize()
        }
    }
    
    var notReachableNetwork: Bool {
        let reachabil = Reachability()!
        
        return reachabil.currentReachabilityStatus == .notReachable
    }
    
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
                    
                    if let expires = json["expires_in"] as? Int64 {
                        self.usr.expiresDate.value = Date(timeIntervalSinceNow: TimeInterval(expires)).UTC
                    }
                    
                    EntitiesManager.shared.alertEntitiesMap(json["news"] as! [[String : Any]])
                    
                    var providerVersionNeedUpdate = false
                    
                    if let providerMD5 = json["static_content_signature"] as? String {
                        providerVersionNeedUpdate = self.usr.providerMD5.value != providerMD5
                        self.usr.providerMD5.value = providerMD5
                    }
                    
                    var patientVersionNeedUpdate = false
                    
                    if let patientMD5 = json["patient_static_content_signature"] as? String {
                        patientVersionNeedUpdate = self.usr.patientMD5.value != patientMD5
                        self.usr.patientMD5.value = patientMD5
                    }
                    
                    if self.applicationState == .patient {
                        if patientVersionNeedUpdate != true {
                            self.usr.loggedIn.onNext(true)
                            onSuccess?()
                            break
                        }
                    } else {
                        if providerVersionNeedUpdate != true {
                            self.usr.loggedIn.onNext(true)
                            onSuccess?()
                            break
                        }
                    }
                    
                    EntitiesManager.shared.offlineData(onSuccess: {
                        self.usr.loggedIn.onNext(true)
                        
                        EntitiesManager.shared.alertEntitiesMap(json["news"] as! [[String : Any]])
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
    
    func performActionWitValidToken(_ action: voidBlock?) {
        
        if needUpdateToken() {
            showHud()
            performLogIn(onSuccess: {
                hideHud()
                action?()
            }, onFail: { str in
                hideHud()
            })
        } else {
            action?()
        }
    }
    
    private func needUpdateToken() -> Bool {
        
        guard let expiresStr = usr.expiresDate.value else {
            return true
        }
        
        guard let expiresDate = Date.dateFormatterUTC.date(from: expiresStr) else {
            return true
        }
        
        let currentDate = Date()
        
        if currentDate > expiresDate {
            return true
        }
        
        return false
    }
    
}
