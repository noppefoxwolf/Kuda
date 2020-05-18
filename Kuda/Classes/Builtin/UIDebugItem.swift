//
//  UIDebugItem.swift
//  Kuda
//
//  Created by Tomoya Hirano on 2020/05/18.
//

import UIKit

public struct UIDebugItem<V: Embedable>: DebugItem {
    public var debugItemTitle: String { "Preview " + String(describing: V.self) }
    public var factory: (() -> V)
    
    public init(_ factory: @escaping (() -> V)) {
        self.factory = factory
    }
    
    public func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (Result<String?, Error>) -> Void) {
        let vc = UIDebugViewController<V>()
        controller.navigationController?.pushViewController(vc, animated: true)
        vc.containerView.embed(factory(), parent: vc)
        completionHandler(.success(nil))
    }
}

internal class UIDebugViewController<V: Embedable>: UIViewController {
    let containerView: ContainerView<V> = .init()
    enum BackgroundMode {
      case light
      case dark
      case smoke
    }
    var backgroundMode: BackgroundMode = .smoke {
      didSet {
        switch backgroundMode {
        case .dark:
          view.backgroundColor = .black
        case .light:
          view.backgroundColor = .white
        case .smoke:
          view.backgroundColor = .lightGray
        }
      }
    }
    var isEnabledBackgroundColorRotation = true
    var onTap: ((V?) -> Void)? = nil
    
    init() {
      super.init(nibName: nil, bundle: nil)
      setup()
    }
    
    private func setup() {
      backgroundMode = .smoke
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func loadView() {
      super.loadView()
      
      containerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(containerView)
      NSLayoutConstraint.activate([
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      ])
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      if isEnabledBackgroundColorRotation {
        switch backgroundMode {
        case .dark:
          backgroundMode = .light
        case .light:
          backgroundMode = .smoke
        case .smoke:
          backgroundMode = .dark
        }
      }
      
      onTap?(containerView.content)
    }
    
    override var canBecomeFirstResponder: Bool {
      return true
    }
}
