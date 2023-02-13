//
//  DynamicHeightForTableView.swift
//  BlockNote app
//
//  Created by Kovs on 13.02.2023.
//

import UIKit

class TableViewAdjustedHeight: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: self.contentSize.width, height: self.contentSize.height + (UIScreen.main.bounds.height / 2))
    }
    
override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
