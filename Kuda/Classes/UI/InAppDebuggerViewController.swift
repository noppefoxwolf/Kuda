//
//  InAppDebuggerViewController.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

import UIKit

enum InAppDebugger {}

class InAppDebuggerViewController: InAppDebuggerViewControllerBase {
    let collectionView: UICollectionView
    let bottomToolView: UIView = .init(frame: .zero)
    let debugItems: [DebugItem]
    
    init(debugItems: [DebugItem]) {
        self.debugItems = debugItems
        let collectionViewLayout = UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 1, leading: 0, bottom: 0, trailing: 0)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                         subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            return section
        }
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        super.init(nibName: nil, bundle: nil)
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
        }
        
        toolBar: do {
            bottomToolView.translatesAutoresizingMaskIntoConstraints = false
            bottomToolView.backgroundColor = .systemBackground
            view.addSubview(bottomToolView)
            NSLayoutConstraint.activate([
                bottomToolView.leftAnchor.constraint(equalTo: view.leftAnchor),
                bottomToolView.rightAnchor.constraint(equalTo: view.rightAnchor),
                bottomToolView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                bottomToolView.heightAnchor.constraint(equalToConstant: view.safeAreaInsets.bottom + 44)
            ])
            
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            bottomToolView.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: bottomToolView.topAnchor),
                label.leftAnchor.constraint(equalTo: bottomToolView.leftAnchor),
                label.rightAnchor.constraint(equalTo: bottomToolView.rightAnchor),
                label.bottomAnchor.constraint(equalTo: bottomToolView.bottomAnchor),
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
            let rightItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(didTapRightItem(_:)))
            navigationItem.rightBarButtonItem = rightItem
        }
    }
    
    @objc private func didTapRightItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InAppDebugger.ListItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension InAppDebuggerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InAppDebugger.ListItemCollectionViewCell
        let item = debugItems[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = debugItems[indexPath.row]
        item.didSelectedDebuggerItem(self) { [weak self] (result) in
            switch result {
            case let .success(message) where message != nil:
                self?.presentAlert(title: "Success", message: message)
            case let .failure(error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            default:
                break
            }
        }
    }
    
    private func presentAlert(title: String, message: String?) {
        DispatchQueue.main.async { [weak self] in
            let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            vc.addAction(.init(title: "OK", style: .cancel, handler: nil))
            self?.present(vc, animated: true, completion: nil)
        }
    }
}

extension InAppDebugger {
    class ListItemCollectionViewCell: UICollectionViewCell {
        private let separatorView: UIView = .init(frame: .zero)
        private let titleLabel: UILabel = UILabel(frame: .zero)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .tertiarySystemBackground
            
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            separatorView.backgroundColor = .separator
            contentView.addSubview(separatorView)
            NSLayoutConstraint.activate([
                separatorView.heightAnchor.constraint(equalToConstant: 1),
                separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
                titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
                contentView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 12),
                contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            ])
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        func configure(item: DebugItem) {
            titleLabel.text = item.debugItemTitle
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
