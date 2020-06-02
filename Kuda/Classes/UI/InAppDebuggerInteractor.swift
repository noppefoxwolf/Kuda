//
//  InAppDebuggerInteractor.swift
//  Pods
//
//  Created Tomoya Hirano on 2020/06/02.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

protocol InAppDebuggerInteractorInput: class {
    func appendHistory(item: DebugItem)
    func toggleFavorite(item: DebugItem)
    func fetch()
}

//MARK: Interactor -
protocol InAppDebuggerInteractorOutput: class {
    func didUpdateHistoryItem(names: [String])
    func didUpdateFavoriteItem(names: [String])
    func didRetrievedItems(historyNames: [String], favoriteNames: [String])
}

class InAppDebuggerInteractor {
    weak var output: InAppDebuggerInteractorOutput!
    let historyKey: String = "dev.noppe.kuda.history"
    let favoriteKey: String = "dev.noppe.kuda.favorite"
    let userDefaults: UserDefaults = UserDefaults.standard
    
    init() {
        userDefaults.register(defaults: [
            historyKey : [],
            favoriteKey: []
        ])
    }
}

extension InAppDebuggerInteractor: InAppDebuggerInteractorInput {
    func fetch() {
        let history: [String] = userDefaults.array(forKey: historyKey) as? [String] ?? []
        let favorite: [String] = userDefaults.array(forKey: favoriteKey) as? [String] ?? []
        output.didRetrievedItems(historyNames: history, favoriteNames: favorite)
    }
    
    func appendHistory(item: DebugItem) {
        var history: [String] = userDefaults.array(forKey: historyKey) as? [String] ?? []
        history.removeAll(where: { $0 == item.debugItemTitle })
        history.insert(item.debugItemTitle, at: 0)
        userDefaults.set(history, forKey: historyKey)
        userDefaults.synchronize()
        output.didUpdateHistoryItem(names: history)
    }
    
    func toggleFavorite(item: DebugItem) {
        let favorite: [String] = userDefaults.array(forKey: favoriteKey) as? [String] ?? []
        if favorite.contains(item.debugItemTitle) {
            removeFavorite(item: item)
        } else {
            addFavorite(item: item)
        }
    }
    
    private func addFavorite(item: DebugItem) {
        var favorite: [String] = userDefaults.array(forKey: favoriteKey) as? [String] ?? []
        favorite.removeAll(where: { $0 == item.debugItemTitle })
        favorite.insert(item.debugItemTitle, at: 0)
        userDefaults.set(favorite, forKey: favoriteKey)
        userDefaults.synchronize()
        output.didUpdateFavoriteItem(names: favorite)
    }
    
    private func removeFavorite(item: DebugItem) {
        var favorite: [String] = userDefaults.array(forKey: favoriteKey) as? [String] ?? []
        favorite.removeAll(where: { $0 == item.debugItemTitle })
        userDefaults.set(favorite, forKey: favoriteKey)
        userDefaults.synchronize()
        output.didUpdateFavoriteItem(names: favorite)
    }
}
