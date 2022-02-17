//
//  noteListObject.swift
//  BlockNote app
//
//  Created by Kovs on 16.02.2022.
//

import UIKit
import CoreData
import TinyConstraints
import SnapKit


class noteListObject: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // setup UI function here..
        setupObject()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // same setup function here
        setupObject()
    }
    
    func setupObject() {
        // https://www.youtube.com/watch?v=_DADWRicrGU
        //  0:28 ------> do it next
        setTitleColor(UIColor(named: "TextForegroundColor"), for: .normal)
        backgroundColor     = UIColor(named: "GreyCloud")
        titleLabel?.font    = UIFont(name: "AvenirNext-DemiBoldItalic", size: 14)
        layer.cornerRadius  = 10
    }
    
    
    
    
}

