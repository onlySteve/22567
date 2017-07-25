//
//  File.swift
//  BugWise
//
//  Created by olbu on 7/1/17.
//  Copyright © 2017 olbu. All rights reserved.
//

import Foundation
import Moya
import RxOptional
import RxSwift
import RxCocoa

struct SearchTrackerModel {
    
    let provider: RxMoyaProvider<API>
    let text: Observable<String>
    let type: SearchType
    
    func trackItems() -> Observable<[SearchEntity]> {
        return text
            .observeOn(MainScheduler.instance)
            .flatMapLatest { searchText -> Observable<[SearchEntity]> in
                return self.searchItems(searchText)
            }
    }
    
    internal func searchItems(_ searchText: String) -> Observable<[SearchEntity]> {
        return provider
            .request(.search(type: type.rawValue, searchString: searchText))
            .mapArray(SearchEntity.self)
    }
}
