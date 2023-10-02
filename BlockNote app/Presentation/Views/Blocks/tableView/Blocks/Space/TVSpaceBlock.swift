//
//  TVSpaceBlock.swift
//  BlockNote app
//
//  Created by Kovs on 14.01.2023.
//

import UIKit

class TVSpaceBlock: UITableViewCell {

    let lineView = UIView(frame: CGRect(x: 20, y: 15, width: UIScreen.main.bounds.width - 40, height: 1))

    override func awakeFromNib() {
        super.awakeFromNib()
        configureLineView()
    }

    private func configureLineView() {
        lineView.backgroundColor = .darkGray
        self.addSubview(lineView)

        NSLayoutConstraint.activate([
            lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
