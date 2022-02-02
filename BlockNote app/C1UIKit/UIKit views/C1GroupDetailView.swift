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
    
#warning("Video - 12:38")
    
    var groupType = GroupType()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = groupType.groupName ?? "Unknown"
        setupScrollView()
        setupContentView()
        setupSwiftUIBarView()
        setupTextView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func setupContentView() {
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
    }
    
    func setupSwiftUIBarView() {
        contentView.addSubview(swiftUIBar)
        swiftUIBar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        swiftUIBar.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        swiftUIBar.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3.5/4).isActive = true
        swiftUIBar.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupTextView() {
        contentView.addSubview(titleLabel) // ---> place title
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: swiftUIBar.bottomAnchor, constant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3.5/4).isActive = true
    }
    
    let swiftUIBar: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .green
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let titleLabel: UILabel = {
           let label = UILabel()
           label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
           label.numberOfLines = 0
           label.sizeToFit()
           label.textColor = UIColor.white
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
}
