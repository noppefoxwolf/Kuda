//
//  InAppDebuggerViewController.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

import UIKit

enum InAppDebugger {}

class InAppDebuggerViewController: InAppDebuggerViewControllerBase {
    enum Section: Int, CaseIterable {
        case favorite
        case recent
        case items
    }
    private var output: InAppDebuggerViewOutput!
    private var target: InAppDebuggerViewTarget!
    private let collectionView: UICollectionView
    private let bottomToolbar: UIToolbar = .init(frame: .zero)
    private let debugItems: [DebugItem]
    private var favoriteItems: [DebugItem] = []
    private var recentItems: [DebugItem] = []
    
    init(debugItems: [DebugItem]) {
        self.debugItems = debugItems
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .list)
        super.init(nibName: nil, bundle: nil)
        setupVIPER()
    }
    
    private func setupVIPER() {
        let presenter = InAppDebuggerPresenter()
        let interactor = InAppDebuggerInteractor()
        output = presenter
        target = presenter
        presenter.view = self
        presenter.interactor = interactor
        interactor.output = presenter
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        super.loadView()
        
        navigationItem.title = Application.current.appName
        navigationItem.largeTitleDisplayMode = .always
        
        collection: do {
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .systemBackground
            view.addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            collectionView.contentInset = .init(top: 0, left: 0, bottom: 44, right: 0)
        }
        
        toolBar: do {
            bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
            bottomToolbar.backgroundColor = .systemBackground
            view.addSubview(bottomToolbar)
            NSLayoutConstraint.activate([
                bottomToolbar.leftAnchor.constraint(equalTo: view.leftAnchor),
                bottomToolbar.rightAnchor.constraint(equalTo: view.rightAnchor),
                bottomToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bottomToolbar.heightAnchor.constraint(equalToConstant: view.safeAreaInsets.bottom + 44)
            ])
            
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            bottomToolbar.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: bottomToolbar.topAnchor),
                label.leftAnchor.constraint(equalTo: bottomToolbar.leftAnchor),
                label.rightAnchor.constraint(equalTo: bottomToolbar.rightAnchor),
                label.bottomAnchor.constraint(equalTo: bottomToolbar.bottomAnchor),
            ])
            let text = "\(Application.current.version)(\(Application.current.build)) - \(Application.current.bundleIdentifier)"
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributedText = NSAttributedString(string: text, attributes: [
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .caption2),
                NSAttributedString.Key.paragraphStyle : paragraphStyle,
            ])
            label.attributedText = attributedText
        }
        
        navigation: do {
            let rightItem = UIBarButtonItem(title: "完了", style: .done, target: target, action: #selector(InAppDebuggerViewTarget.didTapDoneButton))
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InAppDebugger.ListItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(PinSupplementaryView.self, forSupplementaryViewOfKind: PinSupplementaryView.elementKind, withReuseIdentifier: "pin")
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: HeaderSupplementaryView.elementKind, withReuseIdentifier: "header")
        output.viewIsReady()
    }
}

extension InAppDebuggerViewController: InAppDebuggerViewInput {
    func setFavoriteItem(names: [String]) {
        favoriteItems = names.lazy.compactMap({ name in self.debugItems.first(where: { $0.debugItemTitle == name }) }).map({ $0 })
    }
    
    func setHisotryItem(names: [String]) {
        recentItems = names.lazy.compactMap({ name in self.debugItems.first(where: { $0.debugItemTitle == name }) }).prefix(3).map({ $0 })
    }
    
    func presentAlert(title: String, message: String?) {
        DispatchQueue.main.async { [weak self] in
            let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            vc.addAction(.init(title: "OK", style: .cancel, handler: nil))
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension InAppDebuggerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .favorite:
            return favoriteItems.count
        case .recent:
            return recentItems.count
        case .items:
            return debugItems.count
        case .none:
            preconditionFailure()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InAppDebugger.ListItemCollectionViewCell
        switch Section(rawValue: indexPath.section) {
        case .favorite:
            let item = favoriteItems[indexPath.row]
            cell.configure(item: item)
        case .recent:
            let item = recentItems[indexPath.row]
            cell.configure(item: item)
        case .items:
            let item = debugItems[indexPath.row]
            cell.configure(item: item)
        case .none:
            preconditionFailure()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item: DebugItem
        switch Section(rawValue: indexPath.section) {
        case .favorite:
            item = favoriteItems[indexPath.row]
        case .recent:
            item = recentItems[indexPath.row]
        case .items:
            item = debugItems[indexPath.row]
        case .none:
            preconditionFailure()
        }
        output.didSelect(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case PinSupplementaryView.elementKind:
            let supplyView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "pin", for: indexPath) as! PinSupplementaryView
            switch Section(rawValue: indexPath.section) {
            case .favorite:
                let item = favoriteItems[indexPath.row]
                supplyView.setPinned(true)
                supplyView.onTap {
                    self.output.didTapFavoriteButton(item: item)
                }
            case .recent:
                let item = recentItems[indexPath.row]
                supplyView.setPinned(favoriteItems.contains(where: { $0.debugItemTitle == item.debugItemTitle }))
                supplyView.onTap {
                    self.output.didTapFavoriteButton(item: item)
                }
            case .items:
                let item = debugItems[indexPath.row]
                supplyView.setPinned(favoriteItems.contains(where: { $0.debugItemTitle == item.debugItemTitle }))
                supplyView.onTap {
                    self.output.didTapFavoriteButton(item: item)
                }
            case .none:
                preconditionFailure()
            }
            return supplyView
        case HeaderSupplementaryView.elementKind:
            let supplyView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderSupplementaryView
            switch Section(rawValue: indexPath.section) {
            case .favorite:
                supplyView.setText("Favorite")
            case .recent:
                supplyView.setText("Recent")
            case .items:
                supplyView.setText("Debug menu")
            case .none:
                preconditionFailure()
            }
            return supplyView
        default:
            preconditionFailure()
        }
    }
}

extension UIView {
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
