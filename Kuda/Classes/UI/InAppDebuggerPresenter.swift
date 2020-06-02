//
//  InAppDebuggerPresenter.swift
//  Pods
//
//  Created Tomoya Hirano on 2020/06/02.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

@objc protocol InAppDebuggerViewTarget: class {
    func didTapDoneButton()
}

protocol InAppDebuggerViewOutput: class {
    func viewIsReady()
    func didSelect(item: DebugItem)
    func didTapFavoriteButton(item: DebugItem)
}

protocol InAppDebuggerViewInput: class {
    func setFavoriteItem(names: [String])
    func setHisotryItem(names: [String])
    func reloadData()
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func presentAlert(title: String, message: String?)
}

class InAppDebuggerPresenter {
    weak var view: InAppDebuggerViewInput!
    var interactor: InAppDebuggerInteractorInput!
}

extension InAppDebuggerPresenter: InAppDebuggerViewTarget, InAppDebuggerViewOutput {
    func viewIsReady() {
        interactor.fetch()
    }
    
    func didSelect(item: DebugItem) {
        guard let vc = view as? InAppDebuggerViewController else { return }
        item.didSelectedDebuggerItem(vc) { [weak self] (result) in
            switch result {
            case let .success(message) where message != nil:
                self?.view.presentAlert(title: "Success", message: message)
            case let .failure(error):
                self?.view.presentAlert(title: "Error", message: error.localizedDescription)
            default:
                break
            }
        }
        interactor.appendHistory(item: item)
    }
    
    func didTapFavoriteButton(item: DebugItem) {
        interactor.toggleFavorite(item: item)
    }
    
    func didTapDoneButton() {
        view.dismiss(animated: true, completion: nil)
    }
}

extension InAppDebuggerPresenter: InAppDebuggerInteractorOutput {
    func didUpdateHistoryItem(names: [String]) {
        view.setHisotryItem(names: names)
        view.reloadData()
    }
    
    func didUpdateFavoriteItem(names: [String]) {
        view.setFavoriteItem(names: names)
        view.reloadData()
    }
    
    func didRetrievedItems(historyNames: [String], favoriteNames: [String]) {
        view.setFavoriteItem(names: favoriteNames)
        view.setHisotryItem(names: historyNames)
        view.reloadData()
    }
}
