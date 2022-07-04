//
//  zeroPaddingTV.swift
//  BlockNote app
//
//  Created by Kovs on 25.05.2022.
//

import UIKit

@IBDesignable class zeroPaddingTV: UITextView {

    override func layoutSubviews() {
        super.layoutSubviews()
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
    
}
