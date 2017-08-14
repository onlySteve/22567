//
//  ServerAPI.swift
//  BugWise
//
//  Created by olbu on 6/5/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation
import Moya

enum API {
    case authorization(pinCode: String, username: String, surename: String, phone: String, mail: String, location: String, userType: String, sector: String, inHospital: Bool)
    case offlineContent()
    case antibioticDetails(id: String)
    case surviallanceData(SurveillanceRequestEntity)
    case search(type: String, searchString: String?)
    case duplications(values: Array<String>)
    case interactions(values: Array<String>)
}

extension API: TargetType {
    
    var baseURL: URL { return URL(string: "https://www.atozofmedicines.com/app/api.pd/")! }
    
    var path: String {
        switch self {
        case .authorization: return "/getToken"
        case .offlineContent: return "/offlineContent"
        case .antibioticDetails: return "/medicineMonograph"
        case .surviallanceData: return "/sensitivity"
        case .search: return "/search"
        case .duplications: return "/duplications"
        case .interactions: return "/interactions"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .authorization(let pincode, let name, let surename, let phone, let mail, let location, let userType, let sector, let inHospital ): return ["PDCode": pincode, "FirstName": name, "Surname": surename, "MobileNumber": phone, "Email": mail, "Location": location, "UserType": userType, "Sector": sector, "InHospital": inHospital, "PushToken": BusinessModel.shared.pushNotificationToken ?? ""]
        case .offlineContent: return nil
        case .antibioticDetails(let id): return ["lst" : id]
        case .surviallanceData(let requestEntity):
            
            var resultDrugId = ""
            
            if let drugID = requestEntity.antibiotic?.id {
                let index = drugID.index(after: drugID.startIndex)
                resultDrugId = drugID.substring(from: index)
            }
            
            return ["drug" : resultDrugId, "Microbe": requestEntity.microbe?.id ?? "", "Sector": requestEntity.sector, "Location": requestEntity.location]
        case .search(let type,let searchString): return ["mode": type, "string": searchString ?? ""]
        case .duplications(let values):
            let resultArray = values.map { str -> String in
                let index = str.index(after: str.startIndex)
                return str.substring(from: index)
            }
            
            return ["Lst": resultArray.flatMap{ $0 }.joined(separator: "|")]
            
        case .interactions(let values):
            
            let resultArray = values.map { str -> String in
                let index = str.index(after: str.startIndex)
                return str.substring(from: index)
            }
            
            return ["Lst": resultArray.flatMap{ $0 }.joined(separator: "|")]
        }
        
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default // Send parameters in URL
        }
    }
    
    var sampleData: Data {
        switch self {
        case .authorization:
            guard let url = Bundle.main.url(forResource: "authorizationExample", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .offlineContent:
            guard let url = Bundle.main.url(forResource: "offlineContentExample", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        case .antibioticDetails:
            guard let url = Bundle.main.url(forResource: "antibioticDetailsExample", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
            
        case .surviallanceData:
            guard let url = Bundle.main.url(forResource: "surveillanceDataExample", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
            
        case .search:
            guard let url = Bundle.main.url(forResource: "searchExample", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
            
        case .duplications:
            guard let url = Bundle.main.url(forResource: "duplicationsExample", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
            
        case .interactions:
            guard let url = Bundle.main.url(forResource: "interactionsExample", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    
    var task: Task {
        switch self {
        default:
            return .request
        }
    }
}

// MARK:- Helper
private extension String {
    
    var urlEscaped: String {
        return addingPercentEncoding( withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}

