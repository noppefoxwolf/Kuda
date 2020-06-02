//
//  ListItemCollectionViewCell.swift
//  Kuda
//
//  Created by Tomoya Hirano on 2020/06/02.
//

import UIKit

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

