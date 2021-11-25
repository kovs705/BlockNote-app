//
//  ViewController.swift
//  BlockNote app
//
//  Created by Kovs on 13.11.2021.
//

import UIKit
import SwiftUI
import CoreData

class ViewController: UIViewController {
    
    lazy var coreDataStack = CoreDataStack(modelName: "BlockNote_app")
    let mainPageView = UIHostingController(rootView: C1NavigationView())
    
    var groups: [NSManagedObject] = []
                                           
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let viewContext = appDelegate.persistentContainerOffline.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroupType")
        
//        do {
//            groups = try viewContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Couldn't fetch. \(error), \(error.userInfo)")
//        }
        
        let dataFetch: NSFetchRequest<GroupType> = GroupType.fetchRequest()
        
        do {
            let results = try coreDataStack.managedContext.fetch(dataFetch)
            if results.count > 0 {
                print("RESULTS IS: \(String(describing: results.first))")
            } else {
                print("NOTHING!")
            }
        } catch {
            print("WRONG")
        }
        
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

