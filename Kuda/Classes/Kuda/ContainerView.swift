//
//  ContainerView.swift
//  Kuda
//
//  Created by Tomoya Hirano on 2020/05/18.
//

import UIKit

public protocol Embedable {
    
    func __embed(to: UIView, parent: UIViewController)
    
    @discardableResult
    func __digUp(from: UIView) -> Self?
}

extension UIViewController: Embedable {}
extension UIView: Embedable {}

public extension Embedable where Self: UIViewController {
    
    /// Don't call directory.
    func __embed(to: UIView, parent: UIViewController) {
        __digUp(from: to)
        
        willMove(toParent: parent)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        to.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: to.topAnchor),
            view.leftAnchor.constraint(equalTo: to.leftAnchor),
            view.rightAnchor.constraint(equalTo: to.rightAnchor),
            view.bottomAnchor.constraint(equalTo: to.bottomAnchor),
        ])
        
        parent.addChild(self)
        didMove(toParent: parent)
    }
    
    /// Don't call directory.
    @discardableResult
    func __digUp(from: UIView) -> Self? {
        willMove(toParent: nil)
        from.subviews.forEach({ $0.removeFromSuperview() })
        removeFromParent()
        return self
    }
}

public extension Embedable where Self: UIView {
    /// Don't call directory.
    func __embed(to: UIView, parent: UIViewController) {
        __digUp(from: to)
        
        translatesAutoresizingMaskIntoConstraints = false
        to.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: to.topAnchor),
            leftAnchor.constraint(equalTo: to.leftAnchor),
            rightAnchor.constraint(equalTo: to.rightAnchor),
            bottomAnchor.constraint(equalTo: to.bottomAnchor),
        ])
    }
    
    /// Don't call directory.
    @discardableResult
    func __digUp(from: UIView) -> Self? {
        removeFromSuperview()
        return self
    }
}

final class ContainerView<T: Embedable>: UIView {
    private(set) var content: T? = nil
    
    func embed(_ content: T, parent: UIViewController) {
        content.__embed(to: self, parent: parent)
        self.content = content
    }
    
    func digUp() {
        content?.__digUp(from: self)
        content = nil
    }
}
