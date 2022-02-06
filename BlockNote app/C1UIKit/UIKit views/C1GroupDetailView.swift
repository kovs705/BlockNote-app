//
//  C1GroupDetailView.swift
//  BlockNote app
//
//  Created by Kovs on 23.01.2022.
//


import UIKit
import CoreData
import SwiftUI
import TinyConstraints

class C1GroupDetailView: UIViewController {
    
    // MARK: - Properties
    var groupType = GroupType()
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    // MARK: - Views
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .green
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        view.autoresizingMask = .flexibleHeight
        view.showsVerticalScrollIndicator = true
        view.bounces = true
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.frame.size = contentViewSize
        return view
    }()
    
    lazy var loremIpsumLabel: UILabel = {
       let text = UILabel()
        text.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        text.numberOfLines = 0
        text.sizeToFit()
        text.textColor = UIColor.white
        return text
    }()
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = groupType.groupName ?? "Unknown"
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(loremIpsumLabel)
        loremIpsumLabel.center(in: containerView)
        loremIpsumLabel.edges(to: containerView, insets: .top(20) + .left(20) + .right(20))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
