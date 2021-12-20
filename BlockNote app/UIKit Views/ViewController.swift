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
    
    // MARK: - Outlets and variables
    // lazy var coreDataStack = CoreDataStack(modelName: "BlockNote_app")
    // let mainPageView = UIHostingController(rootView: C1NavigationView())
    @IBOutlet weak var groupCollection: UICollectionView!
    // @IBOutlet weak var statView: UIView!
    
    var groups: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Xibs
        groupCollection.register(UINib(nibName: "GroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GroupCollectionViewCell")
        
        
        // MARK: - CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainerOffline.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroupType")
        
        do {
            groups = try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    // MARK: - Logic
    
    
    
}


// MARK: - Extensions
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCollectionViewCell", for: indexPath) as! GroupCollectionViewCell
        // cell.containerView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 170, height: 170)
    }
    
    
}
