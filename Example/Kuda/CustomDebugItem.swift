//
//  CustomDebugItem.swift
//  Kuda_Example
//
//  Created by Tomoya Hirano on 2020/05/18.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Kuda

struct CustomFailureDebugItem: DebugItem {
    enum Error: Swift.Error {
        case unknown
    }
    
    let debugItemTitle: String = "Custom failure item"
    func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (Result<String?, Swift.Error>) -> Void) {
        completionHandler(.failure(Error.unknown))
    }
}

struct CustomSuccessDebugItem: DebugItem {
    let debugItemTitle: String = "Custom success item"
    func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (Result<String?, Swift.Error>) -> Void) {
        completionHandler(.success("Success!!"))
    }
}
