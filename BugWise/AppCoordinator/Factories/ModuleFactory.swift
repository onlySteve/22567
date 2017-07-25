//
//  StartFactory.swift
//  Recept
//
//  Created by olbu on 3/9/17.
//  Copyright © 2017 olbu. All rights reserved.
//

protocol StartModuleFactory {
    func makeStartOutput() -> StartView
}

protocol PinCodeModuleFactory {
    func makePinCodeOutput() -> PinCodeView
}

protocol TabBarModuleFactory {
    func makeTabBarOutput() -> TabBarView
}

protocol ProfileModuleFactory {
    func makeProfileOutput() -> ProfileView
}

protocol HomeModuleFactory {
    func makeHomeOutput() -> HomeView
}

protocol SearchModuleFactory {
    func makeSearchOutput() -> SearchView
}
