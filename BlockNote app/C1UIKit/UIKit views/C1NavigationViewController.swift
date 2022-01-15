//
//  C1NavigationViewController.swift
//  BlockNote app
//
//  Created by Kovs on 12.01.2022.
//

import UIKit
import CoreData

class C1NavigationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    ///
    /// создать ScrollView
    /// добавить containerView с SwiftUI объектами, взяв их из файлов
    /// разобраться где будет UIViewController, агде UIHostingController (проблема с dismiss view)
    ///

    @IBOutlet weak var greetingLabel: UILabel!
    let identifierForCollectionCell = "groupCell"
    var groups: [NSManagedObject] = []
    var hour = Calendar.current.component(.hour, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    func showGreeting() {
        if hour < 4 {
            greetingLabel.text = "Have a good night ✨"
        }
        else if hour < 12 {
            greetingLabel.text = "Good morning!☀️"
        }
        else if hour < 18 {
            greetingLabel.text = "Have a great day! ⛅️"
        }
        else if hour < 23 {
            greetingLabel.text = "Good evening 🌇"
        }
        else {
            greetingLabel.text = "Have a good night ✨"
        }
    }
    
}
