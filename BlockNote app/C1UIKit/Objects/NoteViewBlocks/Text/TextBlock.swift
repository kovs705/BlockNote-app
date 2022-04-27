//
//  TextBlock.swift
//  BlockNote app
//
//  Created by Kovs on 14.04.2022.
//

import UIKit
import CoreData

class TextBlock: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // the width of iPhone 11 is 360
    }

}
