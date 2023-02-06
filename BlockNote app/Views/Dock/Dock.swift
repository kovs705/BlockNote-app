//
//  Dock.swift
//  BlockNote app
//
//  Created by Kovs on 03.02.2023.
//

import UIKit

class Dock: UIView {
    
    let contentView = UIStackView()
    let addBlocksButton = dockButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContentView()
    }
    
    convenience init(parent: UIView) {
        self.init(frame: .zero)
        
        configureDock(to: parent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDock(to parent: UIView) {
        
        backgroundColor = .lightGray
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor),
            heightAnchor.constraint(equalToConstant: 30),
            centerXAnchor.constraint(equalTo: parent.centerXAnchor)
        ])
        
    }
    
    func configureContentView() {
        contentView.alignment = .fill
        contentView.axis = .horizontal
        contentView.spacing = 5
        
        contentView.addArrangedSubview(addBlocksButton)
        contentView.addArrangedSubview(dockButton(fontSize: 14, icon: "plus.rectangle.on.rectangle", color: .systemGray))
    }
    
}
