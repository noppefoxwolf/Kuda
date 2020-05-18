//
//  DebugItem.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/03.
//

public protocol DebugItem {
    var debugItemTitle: String { get }
    func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (Result<String?, Error>) -> Void)
}
