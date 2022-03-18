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
    
    lazy var contentView = UIView()
    lazy var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = noteType.wrappedNoteName
        self.view.backgroundColor = .white
        
    }
    
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
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupHierarchy()
    }
    
    private func setupHierarchy() {

        let blackView = UIView()
        blackView.backgroundColor = UIColor.black
        contentView.addSubview(blackView)
        blackView.snp.makeConstraints { make in
            // The first child view must be pinned to the top
            // of the content view
            make.top.width.equalTo(contentView)
            make.height.equalTo(1000)
        }
        
        let redView = UIView()
        redView.backgroundColor = UIColor.red
        contentView.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.top.equalTo(blackView.snp.bottom)
            make.width.equalTo(contentView)
            make.height.equalTo(1000)
            // The last child view must be pinned to the bottom
            // of the content view
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
}


