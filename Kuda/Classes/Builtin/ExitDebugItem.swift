//
//  ExitDebugItem.swift
//  Kuda
//
//  Created by Tomoya Hirano on 2020/05/18.
//

import UIKit

public struct ExitDebugItem: DebugItem {
    public let debugItemTitle: String = "Exit App"
    public func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (Result<String?, Error>) -> Void) {
        exit(0)
    }
    public init() {}
}
