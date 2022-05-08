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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // the width of iPhone 11 is 360
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        return layoutAttributes
//    }

}
