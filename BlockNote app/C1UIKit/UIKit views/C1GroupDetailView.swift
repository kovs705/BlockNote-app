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
    
    @IBOutlet weak var containerBar: UIView!
    var groupType = GroupType()
    var listCollectionView: UICollectionView?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // left = 40    right = 40      top = 20    height 150      width = 310

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let groupChildView = UIHostingController(rootView: GroupBar(groupType: groupType))
//        addChild(groupChildView)
//        groupChildView.view.frame = containerBar.bounds
//        containerBar.addSubview(groupChildView.view)
//        groupChildView.didMove(toParent: self)
        setupScrollView()
        title = groupType.groupName ?? "Unknown"
        
        
        
        // #warning("Set the tableView of groupType's notes")
        
        // MARK: - Test
        print("Name: \(groupType.wrappedGroupName)")
        print("Number of the group: \(groupType.wrappedNumber)")
        // print("Color of the group: \(groupType.groupColor)")
        
        
    } // end viewDidLoad()
    
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    let groupChildView: UIView = {
        let hostingUIView = UIHostingController(rootView: GroupBar(groupType: groupType))
        hostingUIView.translatesAutoresizingMaskIntoConstraints
        return hostingUIView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
