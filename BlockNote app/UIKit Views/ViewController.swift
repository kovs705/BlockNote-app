//
//  ViewController.swift
//  BlockNote app
//
//  Created by Kovs on 13.11.2021.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    let mainPageView = UIHostingController(rootView: C1NavigationView())

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(mainPageView)
        view.addSubview(mainPageView.view)
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        mainPageView.view.translatesAutoresizingMaskIntoConstraints = false
        mainPageView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainPageView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainPageView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainPageView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }


}

