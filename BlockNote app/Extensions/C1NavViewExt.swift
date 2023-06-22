//
//  VC+Ext.swift
//  BlockNote app
//
//  Created by Kovs on 01.02.2023.
//

import UIKit
import CoreData
import SpriteKit

class C1NavViewExt: UIViewController {
    var groups: [NSManagedObject] = []
    var hour = Calendar.current.component(.hour, from: Date())
    
    // MARK: - CoreData
    func updateData(using sort: String, for fetchRequest: NSFetchRequest<NSManagedObject>, with viewContext: NSManagedObjectContext) {
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sort, ascending: false)]
        
        do {
            groups = try viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchData(using sort: String, for collectionView: UICollectionView) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext       = appDelegate.persistentContainerOffline.viewContext
        let fetchRequest      = NSFetchRequest<NSManagedObject>(entityName: "GroupType")
        
        updateData(using: sort, for: fetchRequest, with: viewContext)
        collectionView.reloadData()
    }
    
    func update(the collectionView: UICollectionView) {
        UIView.animate(withDuration: 0.05, delay: 0, options: [.beginFromCurrentState]) {
            collectionView.reloadInputViews()
        }
    }
    
    // MARK: - ProgressBar
    func configureProgressBarView(progressBarView: UIView) {
        progressBarView.layer.shadowColor = UIColor.black.cgColor
        progressBarView.layer.masksToBounds = false
        progressBarView.layer.cornerRadius = 20
        progressBarView.shadowOffset = CGSize(width: 15, height: 0)
        progressBarView.layer.shadowRadius = 10
        progressBarView.shadowOpacity = 0.3
        progressBarView.layer.shadowPath = CGPath(rect: progressBarView.bounds, transform: nil)
    }
    
    // MARK: - Greeting label
    func showGreeting(greetingLabel: UILabel) {
        if hour < 4 {
            greetingLabel.text = GreetingPhrases.night
        }
        else if hour < 12 {
            greetingLabel.text = GreetingPhrases.morning
        }
        else if hour < 18 {
            greetingLabel.text = GreetingPhrases.day
        }
        else if hour < 23 {
            greetingLabel.text = GreetingPhrases.evening
        }
        else {
            greetingLabel.text = GreetingPhrases.night
        }
    }
    
    // MARK: - ScrollView
    func configureScrollView(scrollView: UIScrollView) {
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
    }
    
    // MARK: - Save group
    func save(groupName: String, groupColor: String, groupCollectionView: UICollectionView) {
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
        
        group.setValue(groupName, forKey: Keys.gName)
        group.setValue(groupColor, forKey: Keys.gColor)
        if groups.isEmpty {
            group.setValue(1, forKey: Keys.gNumber)
        } else {
            group.setValue((groups.count) + 1, forKey: Keys.gNumber)
        }
        
        do {
            groups.insert(group, at: 0)
            print("Successfully added")
            try managedContext.save()
            
            groupCollectionView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

extension C1NavViewExt: SKSnowScene {
    // MARK: - Snow Scene
    func initSnowScene(snowBack: SKView) {
        let snowParticleScene = SnowScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        snowParticleScene.scaleMode = .aspectFill
        snowParticleScene.backgroundColor = .clear
        
        snowBack.allowsTransparency = true
        snowBack.backgroundColor = .clear
        
        snowBack.presentScene(snowParticleScene)
    }
}
