//
//  FeedbackDebugItem.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/03.
//

import UIKit

protocol VisibleViewControllerRepresentable {
    var visibleViewController: UIViewController? { get }
}

struct FeedbackDebugItem: DebugItem {
    let debugItemTitle: String = "Feedbackを投稿する"
    
    func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (Result<String?, Error>) -> Void) {
        guard let keyWindow = UIApplication.shared.findKeyWindow() else {
            completionHandler(.failure(Kuda.Error.notFoundKeyWindow))
            return
        }
        let body = """
        アプリ名：\(Application.current.appName)
        BundleID：\(Application.current.bundleIdentifier)
        バージョン：\(Application.current.version)
        ビルド：\(Application.current.build)
        ViewController：\(topViewController(with: keyWindow.rootViewController!))
        コメント：
        """
        let image = keyWindow.snapshot()
        let vc = UIActivityViewController(activityItems: [body, image as Any].compactMap({ $0 }), applicationActivities: [])
        controller.present(vc, animated: true, completion: nil)
        
        completionHandler(.success(nil))
    }
    
    private func topViewController(with rootViewController: UIViewController) -> UIViewController {
        switch rootViewController {
        case let tabBarController as UITabBarController:
            if let selectedViewController = tabBarController.selectedViewController {
                return topViewController(with: selectedViewController)
            } else {
                break
            }
        case let navigationController as UINavigationController:
            if let visibleViewController = navigationController.visibleViewController {
                return topViewController(with: visibleViewController)
            } else {
                break
            }
        case let visibleReperesentableViewController as VisibleViewControllerRepresentable:
            if let visibleViewController = visibleReperesentableViewController.visibleViewController {
                return topViewController(with: visibleViewController)
            } else {
                break
            }
        default:
            if let presentedViewController = rootViewController.presentedViewController {
                return topViewController(with: presentedViewController)
            } else {
                break
            }
        }
        return rootViewController
    }
}
