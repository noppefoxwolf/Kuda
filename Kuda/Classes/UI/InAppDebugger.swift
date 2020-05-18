//
//  InAppDebugger.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

import UIKit

internal class InAppDebuggerWindow: UIWindow {
    internal static var shared: InAppDebuggerWindow!
    fileprivate var needsThroughTouches: Bool = true
    
    internal static func install(debuggerItems: [DebugItem]) {
        install({ InAppDebuggerWindow(frame: UIScreen.main.bounds) }, debuggerItems: debuggerItems)
    }
    
    internal static func install(windowScene: UIWindowScene, debuggerItems: [DebugItem]) {
        install({ InAppDebuggerWindow(windowScene: windowScene) }, debuggerItems: debuggerItems)
    }
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private static func install(_ factory: (() -> InAppDebuggerWindow), debuggerItems: [DebugItem]) {
        let keyWindow = UIApplication.shared.findKeyWindow()
        shared = factory()
        shared.windowLevel = UIWindow.Level.statusBar + 1
        shared.rootViewController = FloatingViewController(debuggerItems: debuggerItems)
        shared!.makeKeyAndVisible()
        keyWindow?.makeKeyAndVisible()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if InAppDebuggerWindow.shared.needsThroughTouches {
            return super.hitTest(point, with: event) as? FloatingButton
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

fileprivate class FloatingButton: UIButton {}

fileprivate class FloatingViewController: UIViewController {
    private let floatingView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
    private let floatingButton: FloatingButton = FloatingButton(frame: .zero)
    private let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer()
    private let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    private let debuggerItems: [DebugItem]
    private let margin: CGFloat = 16
    private var gestureGap: CGPoint?
    
    init(debuggerItems: [DebugItem]) {
        self.debuggerItems = debuggerItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        super.loadView()
        
        floatingView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        view.addSubview(floatingView)
        
        let image = UIImage(systemName: "ant.fill")
        floatingButton.setImage(image, for: .normal)
        floatingButton.tintColor = UIColor.white
        floatingView.contentView.addSubview(floatingButton)
        floatingButton.frame = floatingView.bounds
        floatingView.alpha = 0.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGesture.addTarget(self, action: #selector(pan(_:)))
        floatingView.addGestureRecognizer(panGesture)
        longPressGesture.addTarget(self, action: #selector(longPress(_:)))
        floatingView.addGestureRecognizer(longPressGesture)
        
        self.floatingView.layer.cornerCurve = .continuous
        self.floatingView.layer.cornerRadius = 22
        self.floatingView.layer.masksToBounds = true
        
        DispatchQueue.main.async { [weak self] in
            self?.floatingView.center = self?.cornerPositions().last ?? .zero
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.floatingView.alpha = 1.0
            })
        }
        
        floatingButton.addTarget(self, action: #selector(didTapAntButton), for: .touchUpInside)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag) {
            InAppDebuggerWindow.shared.needsThroughTouches = false
            completion?()
        }
    }
    
    @objc private func didTapAntButton(_ sender: UIButton) {
        let vc = InAppDebuggerViewController(debugItems: debuggerItems)
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(nc, animated: true, completion: nil)
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        floatingView.alpha = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.floatingView.alpha = 1.0
        }
        let feedback = UIImpactFeedbackGenerator(style: .rigid)
        feedback.prepare()
        feedback.impactOccurred()
    }
    
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            // ジェスチャ座標とオブジェクトの中心座標までの“ギャップ”を計算
            
            let location = gesture.location(in: self.view)
            let gap = CGPoint(x: self.floatingView.center.x - location.x, y: self.floatingView.center.y - location.y)
            self.gestureGap = gap
        
        case .ended:
            let lastObjectLocation = self.floatingView.center
            let velocity = gesture.velocity(in: self.view) // points per second
            
            // 仮想の移動先を計算
            let projectedPosition = CGPoint(x: lastObjectLocation.x + project(initialVelocity: velocity.x, decelerationRate: .fast),
                                            y: lastObjectLocation.y + project(initialVelocity: velocity.y, decelerationRate: .fast))
            // 最適な移動先を計算
            let destination = nearestCornerPosition(projectedPosition)
            
            let initialVelocity = initialAnimationVelocity(for: velocity, from: self.floatingView.center, to: destination)
            
            // iOSの一般的な動きに近い動きを再現
            let parameters = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: initialVelocity)
            let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: parameters)
            
            animator.addAnimations {
                self.floatingView.center = destination
            }
            animator.startAnimation()
            
            self.gestureGap = nil
            
        default:
            // ジェスチャに合わせてオブジェクトをドラッグ
            
            let gestureGap = self.gestureGap ?? CGPoint.zero
            let location = gesture.location(in: self.view)
            let destination = CGPoint(x: location.x + gestureGap.x, y: location.y + gestureGap.y)
            self.floatingView.center = destination

        }
    }
    
    
    // アニメーション開始時の変化率を計算
    private func initialAnimationVelocity(for gestureVelocity: CGPoint, from currentPosition: CGPoint, to finalPosition: CGPoint) -> CGVector {
        // https://developer.apple.com/documentation/uikit/uispringtimingparameters/1649909-initialvelocity
        
        var animationVelocity = CGVector.zero
        let xDistance = finalPosition.x - currentPosition.x
        let yDistance = finalPosition.y - currentPosition.y
        
        if xDistance != 0 {
            animationVelocity.dx = gestureVelocity.x / xDistance
        }
        if yDistance != 0 {
            animationVelocity.dy = gestureVelocity.y / yDistance
        }
        
        return animationVelocity
    }
    
    // 仮想の移動先を計算
    private func project(initialVelocity: CGFloat, decelerationRate: UIScrollView.DecelerationRate) -> CGFloat {
        // https://developer.apple.com/videos/play/wwdc2018/803/
        
        return (initialVelocity / 1000.0) * decelerationRate.rawValue / (1.0 - decelerationRate.rawValue)
    }
    
    // 引数にもっとも近い位置を返す
    private func nearestCornerPosition(_ projectedPosition: CGPoint) -> CGPoint {
        let destinations = cornerPositions()
        let nearestPosition = destinations.sorted(by: {
            return distance(from: $0, to: projectedPosition) < distance(from: $1, to: projectedPosition)
        }).first!
        
        return nearestPosition
    }
    
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
    }
    
    private func cornerPositions() -> [CGPoint] {
        let viewSize = self.view.bounds.size
        let objectSize = self.floatingView.bounds.size
        let xCenter = self.floatingView.bounds.width / 2
        let yCenter = self.floatingView.bounds.height / 2
        let safeAreaInsets = self.view.safeAreaInsets
        
        let topLeft = CGPoint(
            x: self.margin + xCenter + safeAreaInsets.left,
            y: self.margin + yCenter + safeAreaInsets.top
        )
        
        let topRight = CGPoint(
            x: viewSize.width - objectSize.width - self.margin + xCenter - safeAreaInsets.right,
            y: self.margin + yCenter + safeAreaInsets.top
        )
        let bottomLeft = CGPoint(
            x: self.margin + xCenter + safeAreaInsets.left,
            y: viewSize.height - objectSize.height - self.margin + yCenter - safeAreaInsets.bottom
        )
        
        let bottomRight = CGPoint(
            x: viewSize.width - objectSize.width - self.margin + xCenter - safeAreaInsets.right,
            y: viewSize.height - objectSize.height - self.margin + yCenter - safeAreaInsets.bottom
        )
        return [topLeft, topRight, bottomLeft, bottomRight]
    }

}

extension FloatingViewController: InAppDebuggerViewControllerDelegate {
    func didDismiss(_ controller: InAppDebuggerViewControllerBase) {
        InAppDebuggerWindow.shared.needsThroughTouches = true
    }
}

protocol InAppDebuggerViewControllerDelegate: class {
    func didDismiss(_ controller: InAppDebuggerViewControllerBase)
}

open class InAppDebuggerViewControllerBase: UIViewController {
    weak var delegate: InAppDebuggerViewControllerDelegate? = nil
    
    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: { [weak self] in
            guard let self = self else { return }
            self.delegate?.didDismiss(self)
            completion?()
        })
    }
}


extension UIApplication {
    func findKeyWindow() -> UIWindow? {
        (connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows ?? windows)
            .filter({ !($0 is InAppDebuggerWindow) })
            .filter({$0.isKeyWindow}).first
    }
}
