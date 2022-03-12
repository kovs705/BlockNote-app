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
        self.backgroundColor = UIColor(named: "DarkBackground")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // same setup function here
        setupObject()
        self.backgroundColor = UIColor(named: "DarkBackground")
    }
    
    func setupObject() {

        setTitleColor(UIColor(named: "TextForegroundColor"), for: .normal)
        backgroundColor     = UIColor(named: "DarkBackground")
        titleLabel?.font    = UIFont(name: "AvenirNext-DemiBoldItalic", size: 14)
        layer.cornerRadius  = 10
    }
    
    
    
    
}

