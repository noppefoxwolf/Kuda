//
//  HeaderSupplementaryView.swift
//  Kuda
//
//  Created by Tomoya Hirano on 2020/06/02.
//

import Foundation

class HeaderSupplementaryView: UICollectionReusableView {
    static var elementKind: String = "HeaderSupplementaryView"
    private let label: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .secondarySystemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 6),
        ])
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        
        label.textColor = .secondaryLabel
    }
    
    func setText(_ text: String) {
        label.text = text
    }
}
