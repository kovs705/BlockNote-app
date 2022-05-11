//
//  TextBlock.swift
//  BlockNote app
//
//  Created by Kovs on 14.04.2022.
//

import UIKit
import CoreData
import SnapKit

class TextBlock: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        // the width of iPhone 11 is 360
//    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        return layoutAttributes
//    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return cellView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }

}
