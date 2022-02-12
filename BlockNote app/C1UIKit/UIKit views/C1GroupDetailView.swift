//
//  C1GroupDetailView.swift
//  BlockNote app
//
//  Created by Kovs on 23.01.2022.
//


import UIKit
import CoreData
import SwiftUI
import SnapKit

class C1GroupDetailView: UIViewController {
    
    // MARK: - Properties
    var groupType = GroupType()
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    lazy var UIBarSize = CGSize(width: self.view.frame.width, height: 150)
    
    // MARK: - Views
    
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        title = groupType.groupName ?? "Unknown"
        self.view.backgroundColor = .white
        
        // MARK: - Objects
        let scrollView = UIScrollView()
        let containerSwiftUIView = UIView()
        
        // MARK: - ScrollView
        scrollView.bounces = true
        // scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: Int(self.view.frame.size.width), height: 100)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = self.view.frame.size
        
        scrollView.backgroundColor = .gray
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.bottom.left.right.equalTo(view)
        }
        
        // MARK: - ContainerSwiftUIView
        containerSwiftUIView.backgroundColor = .black
        scrollView.addSubview(containerSwiftUIView)
        
        containerSwiftUIView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().offset(-40)
            make.top.equalTo(scrollView.snp.top).offset(10)
            make.height.equalTo(150)
            make.left.equalToSuperview().offset(20)
        }
        
        setupSwiftUIBar()
        
        
        
        func setupSwiftUIBar() {
            let barChildView = UIHostingController(rootView: GroupBar(groupType: groupType))
            addChild(barChildView)
            barChildView.view.frame = containerSwiftUIView.bounds
            containerSwiftUIView.addSubview(barChildView.view)
            barChildView.view.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(containerSwiftUIView)
                make.centerY.equalTo(containerSwiftUIView)
            }
            barChildView.didMove(toParent: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    lazy var containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .gray
//        // view.frame.size = contentViewSize
//        // view.edges(to: scrollView)
//        return view
//    }()
//
//    lazy var viewForSwiftUIBar: UIView = {
//        let swiftUIView = UIView()
//        swiftUIView.backgroundColor = .black
//        swiftUIView.frame.size = UIBarSize
//        return swiftUIView
//    }()
    
//    lazy var loremIpsumLabel: UILabel = {
//       let text = UILabel()
//        text.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//        text.numberOfLines = 0
//        text.sizeToFit()
//        text.textAlignment = .center
//        text.textColor = UIColor.black
//        text.translatesAutoresizingMaskIntoConstraints = false
//        return text
//    }()
    
}
    // MARK: - Garbage
// func setupViews() {
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(scrollView)
//        scrollView.addSubview(containerView)
//
//        // scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        scrollView.snp.makeConstraints { (make) -> Void in
//            make.centerX.equalTo(view)
//            make.width.equalTo(view)
//            make.top.equalTo(view)
//            make.bottom.equalTo(view)
//            make.height.equalTo(600)
//        }
//        scrollView.backgroundColor = .green
//            // scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//            // scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//            // scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//
//        containerView.snp.makeConstraints { (make) -> Void in
//            make.centerX.equalTo(scrollView)
//            make.width.equalTo(scrollView)
//            make.top.equalTo(scrollView)
//            make.bottom.equalTo(scrollView)
//        }
//
//        // containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//            // containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//            // containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//            // containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//
//    }
//

