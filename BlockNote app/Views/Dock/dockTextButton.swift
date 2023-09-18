//
//  dockTextButton.swift
//  BlockNote app
//
//  Created by Kovs on 03.02.2023.
//

import UIKit

class dockTextButton: UIButton {

    let title = UILabel()

    let padding: CGFloat = 5

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray5
        layer.cornerRadius = 10

        addSubview(title)

        title.textColor = .systemGray
        title.font = .systemFont(ofSize: 17)
        title.text = "Aa"
        title.textAlignment = .center

        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
