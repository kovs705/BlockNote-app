//
//  ViewController.swift
//  BlockNote app
//
//  Created by Kovs on 13.11.2021.
//

import UIKit
import CoreData
import SwiftUI

class ViewController: UIViewController {
    
    // lazy var coreDataStack = CoreDataStack(modelName: "BlockNote_app")
    // let mainPageView = UIHostingController(rootView: C1NavigationView())
    @IBOutlet weak var statView: UIView!
    
    var groups: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statView.layer.shadowColor = UIColor(Color.lightPart).cgColor
        statView.layer.shadowOpacity = 0.2
        statView.layer.shadowOffset = CGSize(width: 5, height: 15)
        statView.layer.shadowRadius = 5.0
        
        statView.layer.masksToBounds = false
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainerOffline.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroupType")
        
        do {
            groups = try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
        }
        
        
    }
}
