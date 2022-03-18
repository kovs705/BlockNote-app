//
//  C1NoteView.swift
//  BlockNote app
//
//  Created by Kovs on 17.03.2022.
//

import Foundation
import CoreData
import UIKit
import SnapKit

class C1NoteView: UIViewController, ConstraintRelatableTarget {
    
    var noteType = Note()
    
    lazy var contentView    = UIView()
    lazy var scrollView     = UIScrollView()
    
    lazy var blackView      = UIView()
    lazy var redView        = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = noteType.wrappedNoteName
        self.view.backgroundColor = .white
        
        
        
        scrollView.bounces         = true
        scrollView.backgroundColor = UIColor(named: "DarkBackground")
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
            make.width.equalTo(self)
        }
        
        // Make sure each view contained by the content view
        // has an height (intrisic or specified)
        
        
        blackView.backgroundColor = UIColor.black
        contentView.addSubview(blackView)
        
        blackView.snp.makeConstraints { (make) -> Void in
            // should be on top:
            make.top.width.equalTo(contentView)
            make.height.equalTo(1000) // <---- fot the test
        }
        
        redView.backgroundColor = UIColor.red
        contentView.addSubview(redView)
        
        redView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(blackView.snp.bottom)
            make.width.equalTo(contentView)
            make.height.equalTo(1000)
            // pin to the bottom:
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
}


