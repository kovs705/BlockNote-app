//
//  C1GroupDetailView.swift
//  BlockNote app
//
//  Created by Kovs on 23.01.2022.
//

import UIKit
import CoreData
import SwiftUI

class C1GroupDetailView: UIViewController {
    
    var groupType = GroupType()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // left = 40    right = 40      top = 20    height 150      width = 310

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let groupChildView = UIHostingController(rootView: GroupBar(groupType: groupType))
//        addChild(groupChildView)
//        groupChildView.view.frame = containerBar.bounds
//        containerBar.addSubview(groupChildView.view)
//        groupChildView.didMove(toParent: self)
        
        setupScrollView()
        setupSwiftUIBarViewToTheContainerView()
        
        title = groupType.groupName ?? "Unknown"
        
        // MARK: - Test
        print("Name: \(groupType.wrappedGroupName)")
        print("Number of the group: \(groupType.wrappedNumber)")
        // print("Color of the group: \(groupType.groupColor)")
        
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.backgroundColor = .black
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    let swiftUIBar: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .black
        containerView.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: 150))
        containerView.sizeToFit()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    func setupSwiftUIBarViewToTheContainerView() {
        contentView.addSubview(swiftUIBar)
        swiftUIBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        swiftUIBar.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        swiftUIBar.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
    }
    
    
}
