//
//  TVSpaceBlock.swift
//  BlockNote app
//
//  Created by Kovs on 14.01.2023.
//

import UIKit

class TVSpaceBlock: UITableViewCell {
    
    let lineView = UIView(frame: CGRectMake(20, 15, UIScreen.main.bounds.width-40, 1))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLineView()
    }
    
    private func configureLineView() {
        lineView.backgroundColor = .darkGray
        self.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
