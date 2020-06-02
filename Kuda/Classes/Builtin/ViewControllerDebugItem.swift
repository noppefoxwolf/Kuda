//
//  ViewControllerDebugItem.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/03.
//

import UIKit

public struct ViewControllerDebugItem<T: UIViewController>: DebugItem {
    public var debugItemTitle: String { "Present " + String(describing: T.self) }
    public var factory: (() -> T)
    
    public func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (Result<String?, Error>) -> Void) {
        controller.navigationController?.pushViewController(factory(), animated: true)
        completionHandler(.success(nil))
    }
    
    public init(_ factory: @escaping (() -> T) = { T() }) {
        self.factory = factory
    }
}
