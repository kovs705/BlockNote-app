//
//  MainPageHostingController.swift
//  BlockNote app
//
//  Created by Kovs on 11.01.2022.
//

import UIKit
import CoreData
import SwiftUI
import Combine
import SpriteKit

class MainPageHostingController: UIHostingController<C1NavigationView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: C1NavigationView())
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
