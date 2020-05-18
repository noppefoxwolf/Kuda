//
//  InfoDebugItem.swift
//  Kuda
//
//  Created by Tomoya Hirano on 2020/05/18.
//

public struct InfoDebugItem: DebugItem {
    public let debugItemTitle: String = "Info"
    public func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (Result<String?, Error>) -> Void) {
        controller.navigationController?.pushViewController(UIHostingController(rootView: InfoDebugItemView()), animated: true)
        completionHandler(.success(nil))
    }
    public init() {}
}

import SwiftUI

internal struct InfoDebugItemView: View {
    var body: some View {
        List {
            Text(Application.current.appName)
            Text(Application.current.bundleIdentifier)
            Text(Application.current.version)
            Text(Application.current.build)
            Text("\(Application.current.buildNumber)")
        }
    }
}
