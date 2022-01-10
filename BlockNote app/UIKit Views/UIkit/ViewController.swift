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
            // @IBOutlet weak var groupCollection: UICollectionView!
    // @IBOutlet weak var statView: UIView!
            // @IBOutlet weak var scrollView: UIScrollView!
            // @IBOutlet weak var greetingLabel: UILabel!
    
    var groups: [NSManagedObject] = []
    var hour = Calendar.current.component(.hour, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 300)
        // showGreeting()
        
        // MARK: - Xibs
        // groupCollection.register(UINib(nibName: "GroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GroupCollectionViewCell")
        
        
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
    
    // MARK: - Group Add
    
    @IBAction func addGroup(_ sender: UIButton) {
        let alert = UIAlertController(title: "New group", message: "Add a new group", preferredStyle: .alert)
        
        // save action button
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard
                let textField = alert.textFields?.first,
                let groupToSave = textField.text
            else {
                return
            }
            
            self.save(groupName: groupToSave, groupColor: "GreenAvocado")
            // self.groupCollection.reloadData()
        }
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        
    }
    
    // MARK: - Functions
    func save(groupName: String, groupColor: String) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        let managedContext =
        appDelegate.persistentContainerOffline.viewContext
        let entity =
        NSEntityDescription.entity(forEntityName: "GroupType",
                                   in: managedContext)!
        let group = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        group.setValue(groupName, forKey: "groupName")
        group.setValue(groupColor, forKey: "groupColor")
        // group.setValue(number, forKey: "number")
        
        do {
            groups.append(group)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
//    func showGreeting() {
//        if hour < 4 {
//            greetingLabel.text = "Have a good night ✨"
//        }
//        else if hour < 12 {
//            greetingLabel.text = "Good morning!☀️"
//        }
//        else if hour < 18 {
//            greetingLabel.text = "Have a great day! ⛅️"
//        }
//        else if hour < 23 {
//            greetingLabel.text = "Good evening 🌇"
//        }
//        else {
//            greetingLabel.text = "Have a good night ✨"
//        }
//    }

    
    
}


// MARK: - Extensions
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let group = groups[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCollectionViewCell", for: indexPath) as! GroupCollectionViewCell
        // cell.containerView.backgroundColor = group.value(forKey: "groupColor") as?
        cell.containerView.backgroundColor = UIColor(returnColorFromString(nameOfColor: group.value(forKey: "groupColor") as! String))
        cell.groupNameLabel.text = group.value(forKey: "groupName") as? String
        cell.numberOfNotesLabel.text = "\(group.value(forKey: "noteTypes") ?? 0) notes"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 175, height: 175)
    }
    
}
