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
        // textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        textContainer.lineFragmentPadding = 0
    }
    
}
