//
//  Application.swift
//  Kuda
//
//  Created by Tomoya Hirano on 2020/05/18.
//

import UIKit

struct Application {
    static var current: Application = .init()
    
    var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    
    var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var build: String {
        Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as! String
    }
    
    var buildNumber: Int {
        Int(build) ?? 0
    }
    
    var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? ""
    }
}
