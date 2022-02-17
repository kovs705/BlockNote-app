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
import simd

class C1GroupDetailView: UIViewController {
    
    // MARK: - Properties
    var groupType = GroupType()
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    lazy var UIBarSize = CGSize(width: self.view.frame.width, height: 150)
    
    // MARK: - Views
    lazy var scrollView           = UIScrollView()
    lazy var containerSwiftUIView = UIView()
    lazy var listOfNotes          = UIStackView()
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        title = groupType.groupName ?? "Unknown"
        self.view.backgroundColor = .white
        
        
        
        // MARK: - ScrollView
        scrollView.bounces = true
        // scrollView.isPagingEnabled = true
        scrollView.contentSize                  = CGSize(width: Int(self.view.frame.size.width), height: 100)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize                  = self.view.frame.size
        scrollView.backgroundColor              = UIColor(named: "DarkBackground")
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.bottom.left.right.equalTo(view)
        }
        
        
        
        // MARK: - ContainerSwiftUIView
        containerSwiftUIView.backgroundColor = UIColor(named: "DarkBackground")
        scrollView.addSubview(containerSwiftUIView)
        
        containerSwiftUIView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().offset(-40)
            make.top.equalTo(scrollView.snp.top).offset(10)
            make.height.equalTo(150)
            make.left.equalToSuperview().offset(20)
        }
        setupSwiftUIBar()
        
        
        
        // MARK: - StackView
        scrollView.addSubview(listOfNotes)
        listOfNotes.backgroundColor = .black
        
        listOfNotes.axis         = .vertical
        listOfNotes.distribution = .equalSpacing
        listOfNotes.spacing      = 10
        // https://www.youtube.com/watch?v=_DADWRicrGU
        // 05:06 -----> work on it
        
        listOfNotes.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().offset(-40)
            make.top.equalTo(containerSwiftUIView.snp.bottom).offset(20)
            #warning("Work on dynamic height")
            make.height.equalTo(300)
            make.left.equalToSuperview().offset(20)
        }
        addNotesToTheNoteList()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    
    func addNotesToTheNoteList() {
        var notesArray = groupType.typesOfNoteArray
        #warning("make a function to add note")
        
        for note in notesArray {
            let noteItem = noteListObject()
            noteItem.setTitle("\(note.wrappedNoteName)", for: .normal)
            listOfNotes.addArrangedSubview(noteItem)
        }
    }
    
}


    
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
