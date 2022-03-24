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
    // #warning("change greetingLabel with ContainerVIew for SwiftUI")
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var groupCollectionView: UICollectionView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let identifierForCollectionCell = "groupDetail"
    
    var groups: [NSManagedObject] = []
    // var groupsGroupType: [GroupType] = []
    
    var hour = Calendar.current.component(.hour, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // groupCollectionView.register(UINib(nibName: "GroupCollectionCell", bundle: nil), forCellWithReuseIdentifier: identifierForCollectionCell)
        
        groupCollectionView.allowsSelection = true
        groupCollectionView.dataSource      = self
        groupCollectionView.delegate        = self
        
        // MARK: - Sorting func
        func sortGroupsByNumber(_ groups: [GroupType]) -> [GroupType] {
            groups.sorted { groupA, groupB in
                groupA.number < groupB.number
            }
        }
        
        // MARK: - CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext       = appDelegate.persistentContainerOffline.viewContext
        let fetchRequest      = NSFetchRequest<NSManagedObject>(entityName: "GroupType")
        let sort              = NSSortDescriptor(key: "number", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            groups = try viewContext.fetch(fetchRequest)
            // sortGroupsByNumber(groups)
        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
        }
        
        // MARK: - Design
        showGreeting()
        // #warning("work on shadow bug") --> completed
        progressBarView.layer.cornerRadius = 20
        progressBarView.shadowOffset = CGSize(width: 5, height: 5)
        progressBarView.layer.shadowRadius = 10
        progressBarView.shadowOpacity = 0.3
        progressBarView.layer.shadowPath = CGPath(rect: progressBarView.bounds, transform: nil)
        // progressBarView.shadowColor = UIColor.black
        
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? C1GroupDetailView,
           let groupIndex = groupCollectionView.indexPathsForSelectedItems?.first {
            destination.groupType = self.groups[groupIndex.row] as! GroupType
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
    
    
    
    @IBAction func addGroup(_ sender: UIButton) {
        let alert = UIAlertController(title: "New group", message: "Enter a name for the group", preferredStyle: .alert)
        
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
        group.setValue((groups.count) + 1, forKey: "number")
        #warning("work on this number count")
        // group.setValue(number, forKey: "number")
        
        do {
            groups.append(group)
            print("Successfully added")
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let cell = sender as? UICollectionViewCell,
//           let indexPath = self.groupCollectionView.indexPath(for: cell) {
//            let groupDetailVC = segue.destination as! C1GroupDetailView
//            groupDetailVC.groupType = self.groups[indexPath.row] as! GroupType
//        }
//    }
}

// MARK: - UICollectionView

extension C1NavigationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let group = self.groups[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierForCollectionCell, for: indexPath as IndexPath) as! groupViewCell
        // cell.groupName.text = group.value(forKey: "groupName") as? String
        cell.setGroupName(label: group.value(forKey: "groupName") as! String)
        cell.setBackground(color: group.value(forKey: "groupColor") as! String)
        // cell.setNumber(numLabel: "String", number: 1)
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        // cell.numberOfNotes.text = "\(group.value(forKey: "noteTypes") ?? 0) notes"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 165, height: 165)
        }
    
    // MARK: - Segue for the groupDetail
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // self.performSegue(withIdentifier: "groupDetail", sender: indexPath)
        // print("clicked")
    }
}

