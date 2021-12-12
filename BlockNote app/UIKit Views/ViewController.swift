//
//  ViewController.swift
//  BlockNote app
//
//  Created by Kovs on 13.11.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // lazy var coreDataStack = CoreDataStack(modelName: "BlockNote_app")
    // let mainPageView = UIHostingController(rootView: C1NavigationView())
    
    var groups: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
