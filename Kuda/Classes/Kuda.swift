//
//  Kuda.swift
//  Kuda
//
//  Created by Tomoya Hirano on 2020/05/18.
//

import UIKit

public enum Kuda {
    public static func install(debuggerItems: [DebugItem]) {
        InAppDebuggerWindow.install(debuggerItems: debuggerItems)
    }
    
    public static func install(windowScene: UIWindowScene, debuggerItems: [DebugItem]) {
        InAppDebuggerWindow.install(windowScene: windowScene, debuggerItems: debuggerItems)
    }
}
