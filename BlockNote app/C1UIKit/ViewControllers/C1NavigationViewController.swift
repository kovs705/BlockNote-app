//
//  C1NavigationViewController.swift
//  BlockNote app
//
//  Created by Kovs on 12.01.2022.
//

import UIKit
import CoreData
import SpriteKit

class C1NavigationViewController: UIViewController {
    
    // #warning("change greetingLabel with ContainerVIew for SwiftUI")
    @IBOutlet var background: UIView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var groupCollectionView: UICollectionView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var snowBackgroundScene: SKView!
    
    let identifierForCollectionCell = "groupDetail"
    
    var groups: [NSManagedObject] = []
    
    var hour = Calendar.current.component(.hour, from: Date())
    
    // animations:
    // let animationDuration: Double = 5.0
    // let delayBase: Double = 1.0
    
    // MARK: - CoreData
    func fetchData() {
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
    }
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBarView.layer.shadowColor = UIColor.black.cgColor
        progressBarView.layer.masksToBounds = false

        
        groupCollectionView.allowsSelection = true
        groupCollectionView.dataSource      = self
        groupCollectionView.delegate        = self
        
        // MARK: - Sorting func
        func sortGroupsByNumber(_ groups: [GroupType]) -> [GroupType] {
            groups.sorted { groupA, groupB in
                groupA.number < groupB.number
            }
        }
        
        // MARK: - fetch data
        fetchData()
        
        // MARK: - Design
        showGreeting()
        
        progressBarView.layer.cornerRadius = 20
        progressBarView.shadowOffset = CGSize(width: 15, height: 0)
        progressBarView.layer.shadowRadius = 10
        progressBarView.shadowOpacity = 0.3
        progressBarView.layer.shadowPath = CGPath(rect: progressBarView.bounds, transform: nil)
        
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        
        initSnowScene()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC,
           let groupIndex = groupCollectionView.indexPathsForSelectedItems?.first {
            destination.groupType = self.groups[groupIndex.row] as! GroupType
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchData()
        groupCollectionView.reloadData()
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
    // MARK: - Save group
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
            groups.insert(group, at: 0)

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
    
    private func initSnowScene() {
        let snowParticleScene = SnowScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        snowParticleScene.scaleMode = .aspectFill
        snowParticleScene.backgroundColor = .clear
        
        snowBackgroundScene.allowsTransparency = true
        snowBackgroundScene.backgroundColor = .clear
        
        snowBackgroundScene.presentScene(snowParticleScene)
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
        
        let numberOfNotes = group.value(forKey: "noteTypes") as! Set<Note>
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierForCollectionCell, for: indexPath as IndexPath) as! groupViewCell
        // cell.groupName.text = group.value(forKey: "groupName") as? String
        cell.setGroupName(label: group.value(forKey: "groupName") as? String ?? "default name")
        cell.setBackground(color: group.value(forKey: "groupColor") as? String ?? "GreenAvocado")
        cell.setNumber(number: numberOfNotes.count)
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - Animation
        // cell.alpha = 0
        // cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//        UIView.animate(withDuration: animationDuration) {
//            cell.alpha = 1
//            cell.transform = .identity
//          }
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfGroupsPerRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfGroupsPerRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfGroupsPerRow))
        
        return CGSize(width: size, height: size)
        
            // return CGSize(width: 165, height: 165)
        }
    
    // MARK: - Segue for the groupDetail
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         self.performSegue(withIdentifier: "groupDetail", sender: indexPath)
//         print("clicked")
    }
}

extension C1NavigationViewController: detail_vc_Delegate {
    // place a func to update UICollectionView in rootVC just after deleting a group in detailVC:
    func deleteAndUpdate() {
        _ = navigationController?.popViewController(animated: true)
        self.groupCollectionView.reloadData()
    }
    func closeAndDelete() {
        groupCollectionView.reloadData()
    }
}
