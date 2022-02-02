//
//  Code to test.swift
//  BlockNote app
//
//  Created by Kovs on 02.02.2022.
//

import UIKit
import CoreData
import SwiftUI

class C2GroupDetailView: UIViewController {
    
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
        
        setupScrollView()   // ---> placed ScrollView and ContentView for objects inside
        setupView()        // ---> placing objects on ContentView
        
        // setupSwiftUIBarViewToTheContainerView()
        
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
    
    let titleLabel: UILabel = {
           let label = UILabel()
           label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
           label.numberOfLines = 0
           label.sizeToFit()
           label.textColor = UIColor.white
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       let subtitleLabel: UILabel = {
           let label = UILabel()
           label.text = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
           label.numberOfLines = 0
           label.sizeToFit()
           label.textColor = UIColor.white
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let swiftUIBar: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.sizeToFit()
        uiView.frame(forAlignmentRect: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.width - 40, height: 150))
        uiView.backgroundColor = .green
        return uiView
    }()
    
    
    
    
    func setupView() {
        contentView.addSubview(titleLabel) // ---> place title
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3.5/4).isActive = true
        
        contentView.addSubview(swiftUIBar) // ---> place UIView with SwiftUI object inside
        swiftUIBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        swiftUIBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        swiftUIBar.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3.5/4).isActive = true
        swiftUIBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 30).isActive = true
    }
    
    
}
