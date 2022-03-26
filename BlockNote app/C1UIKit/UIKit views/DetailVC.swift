//
//  DetailVCViewController.swift
//  BlockNote app
//
//  Created by Kovs on 25.03.2022.
//

import UIKit
import CoreData
import SwiftUI

class DetailVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var groupType = GroupType()
    var noteObject = Note()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = groupType.groupName
        
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        
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
