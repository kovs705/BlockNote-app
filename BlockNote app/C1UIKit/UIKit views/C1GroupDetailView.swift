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
#warning("Add Stack view with spacing of 20 + addSubview of SwiftUI right in ContainerView")
    // MARK: - Properties
    var groupType = GroupType()
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    lazy var UIBarSize = CGSize(width: self.view.frame.width, height: 150)
    
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = groupType.groupName ?? "Unknown"
        setupViews()
        setupViewsInContainer()
        setupSwiftUIBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
            containerView.backgroundColor = .black // ---> Black background
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
    }
    
    func setupViewsInContainer() {
        containerView.addSubview(viewForSwiftUIBar)
        viewForSwiftUIBar.center(in: containerView)
            viewForSwiftUIBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
            viewForSwiftUIBar.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 3.5/4).isActive = true
            viewForSwiftUIBar.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
//        containerView.addSubview(loremIpsumLabel)
//
//        // loremIpsumLabel.center(in: containerView)
//            loremIpsumLabel.topAnchor.constraint(equalTo: viewForSwiftUIBar.bottomAnchor, constant: 20).isActive = true
//            loremIpsumLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 3.5/4).isActive = true
    }
    
    func setupSwiftUIBar() {
        let barChildView = UIHostingController(rootView: GroupBar(groupType: groupType))
        addChild(barChildView)
        barChildView.view.frame = viewForSwiftUIBar.bounds
        viewForSwiftUIBar.addSubview(barChildView.view)
        barChildView.didMove(toParent: self)
    }
    
    // MARK: - Views
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .white
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        //view.edgesToSuperview()
        view.autoresizingMask = .flexibleHeight
        view.showsVerticalScrollIndicator = true
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = true
        view.bounces = true
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = contentViewSize
        // view.edges(to: scrollView)
        return view
    }()
    
    lazy var viewForSwiftUIBar: UIView = {
        let swiftUIView = UIView()
        swiftUIView.backgroundColor = returnUIColorFromString(string: "PurpleBlackBerry")
        swiftUIView.frame.size = UIBarSize
        return swiftUIView
    }()
    
    lazy var loremIpsumLabel: UILabel = {
       let text = UILabel()
        text.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        text.numberOfLines = 0
        text.sizeToFit()
        text.textAlignment = .center
        text.textColor = UIColor.black
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
}
