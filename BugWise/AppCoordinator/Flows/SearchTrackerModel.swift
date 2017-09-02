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
    
    func trackItems() -> Observable<[SearchModuleItem]> {
        return text
            .observeOn(MainScheduler.instance)
            .flatMapLatest { searchText -> Observable<[SearchModuleItem]> in
                return self.searchItems(searchText)
            }
    }
    
    internal func searchItems(_ searchText: String) -> Observable<[SearchModuleItem]> {
        return provider
            .request(.search(type: type.rawValue, searchString: searchText))
            .mapArray(SearchModuleItem.self)
    }
}
