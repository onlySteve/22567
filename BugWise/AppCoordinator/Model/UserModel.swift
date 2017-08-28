 //
//  UserModel.swift
//  Recept
//
//  Created by olbu on 3/8/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation
import RxSwift

enum UserType: String {
    case doctor = "Doctor"
    case pharmacist = "Pharmacist"
    case nurse = "Nurse"
    case others = "Other"
    
    static let allValues = [doctor, pharmacist, nurse, others]
}

enum Sector: String {
    case privateType = "Private"
    case publicType = "Public"
    case both = "Both"
    
    static let surveillanceArray = [privateType, publicType]
    static let profileArray = [privateType, publicType, both]
}

enum Location: String {
    case Bloemfontein = "Bloemfontein"
    case CapeTown = "Cape Town"
    case Durban = "Durban"
    case EastLondon = "East London"
    case Johannesburg = "Johannesburg"
    case Mthatha = "Mthatha"
    case Pietermaritzburg = "Pietermaritzburg"
    case PortElizabeth = "Port Elizabeth"
    case Pretoria = "Pretoria"
    
    static let allValues = [Bloemfontein, CapeTown, Durban, EastLondon, Johannesburg, Mthatha, Pietermaritzburg, PortElizabeth, Pretoria]
}

fileprivate enum synchronizeUsr: String {
    case pinCode = "UsrPinCode"
    case name = "UsrName"
    case sureName = "UsrSureName"
    case phone = "UsrPhone"
    case mail = "UsrMail"
    case location = "location"
    case userType = "UsrType"
    case sector = "UsrSector"
    case workInHospital = "UsrWorkInHospital"
    case loggedIn = "UsrLoggedIn"
    case notificationsEnabled = "UsrNotificationsEnabled"
    case token = "UsrToken"
    case providerMD5 = "UsrProviderMD5"
    case patientMD5 = "UsrPatientMD5"
}

class UserModel {
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    private let disposeBag = DisposeBag()
    
    private var privateLoggedIn: Bool = UserDefaults.standard.bool(forKey: synchronizeUsr.loggedIn.rawValue)
    
    var token: Variable<String?> = Variable(UserDefaults.standard.string(forKey: synchronizeUsr.token.rawValue))
    
    var pinCode: Variable<String?> = Variable(UserDefaults.standard.string(forKey: synchronizeUsr.pinCode.rawValue))
    var userName: Variable<String?> = Variable(UserDefaults.standard.string(forKey: synchronizeUsr.name.rawValue))
    var sureName: Variable<String?> = Variable(UserDefaults.standard.string(forKey: synchronizeUsr.sureName.rawValue))
    var phone: Variable<String?> = Variable(UserDefaults.standard.string(forKey: synchronizeUsr.phone.rawValue))
    var mail: Variable<String?> = Variable(UserDefaults.standard.string(forKey: synchronizeUsr.mail.rawValue))
    var location: Variable<Location> = Variable(Location(rawValue: UserDefaults.standard.string(forKey: synchronizeUsr.location.rawValue) ?? Location.Bloemfontein.rawValue)!)
    var userType: Variable<UserType> = Variable(UserType(rawValue: UserDefaults.standard.string(forKey: synchronizeUsr.userType.rawValue) ?? UserType.others.rawValue)!)
    var sector: Variable<Sector> = Variable(Sector(rawValue: UserDefaults.standard.string(forKey: synchronizeUsr.sector.rawValue) ?? Sector.privateType.rawValue)!)
    var workInHospital: Variable<Bool> = Variable(UserDefaults.standard.bool(forKey: synchronizeUsr.workInHospital.rawValue))
    var loggedIn: ReplaySubject<Bool> = ReplaySubject<Bool>.create(bufferSize: 1)
    var notificationsEnabled: Variable<Bool> = Variable((UserDefaults.standard.object(forKey: synchronizeUsr.notificationsEnabled.rawValue) != nil) ? UserDefaults.standard.bool(forKey: synchronizeUsr.notificationsEnabled.rawValue) : true)
    var providerMD5: Variable<String?> = Variable(UserDefaults.standard.string(forKey: synchronizeUsr.providerMD5.rawValue))
    var patientMD5: Variable<String?> = Variable(UserDefaults.standard.string(forKey: synchronizeUsr.patientMD5.rawValue))
    
    init() {
        
        loggedIn.onNext(privateLoggedIn)
        
        loggedIn
            .asObserver()
            .subscribe { value in
                
                if let value = value.element {
                    
                    self.privateLoggedIn = value
                    
                    if value == false { self.clear() }
                    
                    self.save()
                }
            
            }.addDisposableTo(disposeBag)

    }
    
    var isValidCredentials: Bool {
        get{
            return (userName.value?.characters.count)! > 1 && (sureName.value?.characters.count)! > 1 && (phone.value?.characters.count)! > 1 && (mail.value?.characters.count)! > 1
        }
    }
    
    func save() {
        userDefaults.set(pinCode.value, forKey: synchronizeUsr.pinCode.rawValue)
        userDefaults.set(userName.value, forKey: synchronizeUsr.name.rawValue)
        userDefaults.set(sureName.value, forKey: synchronizeUsr.sureName.rawValue)
        userDefaults.set(phone.value, forKey: synchronizeUsr.phone.rawValue)
        userDefaults.set(mail.value, forKey: synchronizeUsr.mail.rawValue)
        userDefaults.set(location.value.rawValue, forKey: synchronizeUsr.location.rawValue)
        userDefaults.set(userType.value.rawValue, forKey: synchronizeUsr.userType.rawValue)
        userDefaults.set(sector.value.rawValue, forKey: synchronizeUsr.sector.rawValue)
        userDefaults.set(workInHospital.value, forKey: synchronizeUsr.workInHospital.rawValue)
        userDefaults.set(privateLoggedIn, forKey: synchronizeUsr.loggedIn.rawValue)
        userDefaults.set(notificationsEnabled.value, forKey: synchronizeUsr.notificationsEnabled.rawValue)
        userDefaults.set(token.value, forKey: synchronizeUsr.token.rawValue)
        userDefaults.set(patientMD5.value, forKey: synchronizeUsr.patientMD5.rawValue)
        userDefaults.set(providerMD5.value, forKey: synchronizeUsr.providerMD5.rawValue)
        
        userDefaults.synchronize()
    }
    
    func clear() {
        privateLoggedIn = false
        pinCode = Variable(nil)
        userName = Variable(nil)
        sureName = Variable(nil)
        phone = Variable(nil)
        mail = Variable(nil)
        location = Variable(.Bloemfontein)
        userType = Variable(.others)
        sector = Variable(.privateType)
        workInHospital = Variable(false)
        token = Variable(nil)
        patientMD5 = Variable(nil)
        providerMD5 = Variable(nil)
        
        save()
    }
}
