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
    var mainView: MainView { return self.view as! MainView }
    
    // let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = groupType.groupName ?? "Unknown"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }
    
    
    
}

class MainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setupViews()
        setupScrollViewConstraints()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
    }
    
    fileprivate func setupScrollViewConstraints() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        mainScrollView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        mainScrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        mainScrollView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    
    let contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .green
        return view
    }()
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
}
