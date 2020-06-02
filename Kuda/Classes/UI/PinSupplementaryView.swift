//
//  PinSupplementaryView.swift
//  Kuda
//
//  Created by Tomoya Hirano on 2020/06/02.
//

import Foundation
import UIKit

class PinSupplementaryView: UICollectionReusableView {
    static var elementKind: String = "PinSupplementaryView"
    let button: UIButton = .init()
    private var onTapHandler: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.rightAnchor.constraint(equalTo: rightAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leftAnchor.constraint(equalTo: leftAnchor),
        ])
    }
    
    func setPinned(_ pinned: Bool) {
        button.setImage(pinned ? UIImage(systemName: "pin.fill") : UIImage(systemName: "pin"), for: .normal)
    }
    
    func onTap(_ handler: @escaping () -> Void) {
        button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        self.onTapHandler = handler
    }
    
    @objc private func didTap(_ sender: UIButton) {
        onTapHandler?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button.removeTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
}
