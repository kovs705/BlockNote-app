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
    
//    required init?(coder aDecoder: NSCoder) {
//        // self.groupType = "groupType"
//        super.init(coder: aDecoder)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let groupChildView = UIHostingController(rootView: GroupBar(groupType: groupType))
        addChild(groupChildView)
        groupChildView.view.frame = containerBar.bounds
        containerBar.addSubview(groupChildView.view)
        groupChildView.didMove(toParent: self)
        
        title = groupType.groupName ?? "Unknown"
        
        #warning("Set the tableView of groupType's notes")
        
        // MARK: - Test
        print("Name: \(groupType.wrappedGroupName)")
        print("Number of the group: \(groupType.wrappedNumber)")
        print("Color of the group: \(groupType.groupColor)")
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
