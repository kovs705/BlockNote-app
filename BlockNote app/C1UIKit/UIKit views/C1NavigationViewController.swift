//
//  C1NavigationViewController.swift
//  BlockNote app
//
//  Created by Kovs on 12.01.2022.
//

import UIKit
import CoreData

class C1NavigationViewController: UIViewController {
    
    ///
    /// создать ScrollView
    /// добавить containerView с SwiftUI объектами, взяв их из файлов
    /// разобраться где будет UIViewController, агде UIHostingController (проблема с dismiss view)
    ///
    #warning("change greetingLabel with ContainerVIew for SwiftUI")
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var groupCollectionView: UICollectionView!
    @IBOutlet weak var progressBarView: UIView!
    
    let identifierForCollectionCell = "group"
    
    var groups: [NSManagedObject] = []
    
    var hour = Calendar.current.component(.hour, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupCollectionView.register(UINib(nibName: "GroupCollectionCell", bundle: nil), forCellWithReuseIdentifier: identifierForCollectionCell)
        
        // MARK: - CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainerOffline.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroupType")
        
        do {
            groups = try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
        }
        // MARK: - Design
        showGreeting()
        progressBarView.layer.cornerRadius = 20
        progressBarView.shadowOffset = CGSize(width: 5, height: 5)
        progressBarView.layer.shadowRadius = 10
        progressBarView.shadowOpacity = 0.3
        progressBarView.layer.shadowPath = CGPath(rect: progressBarView.bounds, transform: nil)
        // progressBarView.shadowColor = UIColor.black
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
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
            groupCollectionView.reloadData()
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

// MARK: - UICollectionView

extension C1NavigationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let group = self.groups[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierForCollectionCell, for: indexPath as IndexPath) as! GroupCollectionCell
        cell.groupName.text = group.value(forKey: "groupName") as? String
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        // cell.numberOfNotes.text = "\(group.value(forKey: "noteTypes") ?? 0) notes"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 175, height: 175)
        }
}
