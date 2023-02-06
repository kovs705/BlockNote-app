//
//  dockTextButton.swift
//  BlockNote app
//
//  Created by Kovs on 03.02.2023.
//

import UIKit

class dockTextButton: UIButton {
    
    let back = UIView()
    let title = UILabel()
    
    let padding: CGFloat = 5

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    convenience init(to parent: UIView, leftObject: UIButton, rightObject: UIButton) {
        self.init(frame: .zero)
        
        NSLayoutConstraint.activate([
            back.heightAnchor.constraint(equalToConstant: 18),
            back.topAnchor.constraint(equalTo: parent.topAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        back.addSubview(title)
        
        back.backgroundColor = .lightGray
        back.layer.cornerRadius = 10
        
        title.textColor = .gray
        title.font = .systemFont(ofSize: 14)
        
        NSLayoutConstraint.activate([
        ])
    }

}
