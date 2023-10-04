//
//  DynamicHeightForTableView.swift
//  BlockNote app
//
//  Created by Kovs on 13.02.2023.
//

import UIKit

class TableViewAdjustedHeight: UITableView {
//    override var intrinsicContentSize: CGSize {
//        UIView.performWithoutAnimation {
//            self.layoutIfNeeded()
//        }
//        return CGSize(width: self.contentSize.width, height: self.contentSize.height + (UIScreen.main.bounds.height / 2))
//    }

    override var contentSize: CGSize {
        didSet {
            UIView.performWithoutAnimation {
                self.invalidateIntrinsicContentSize()
            }
        }
    }

    override func reloadData() {
        UIView.performWithoutAnimation {
            super.reloadData()
            self.invalidateIntrinsicContentSize()
        }
    }
}
