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
    
    let groupType = GroupType()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        #warning("Work on UI of the button, maybe place the name on the left side and something on the right")
        setupObject()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // same setup function here
        setupObject()
    }
    
    func setupObject() {

        setTitleColor(UIColor(named: "TextForegroundColor"), for: .normal)
        backgroundColor     = UIColor(named: "GreyCloud")
        titleLabel?.font    = UIFont(name: "AvenirNext-DemiBoldItalic", size: 14)
        layer.cornerRadius  = 10
    }
    
    
    
    
}

