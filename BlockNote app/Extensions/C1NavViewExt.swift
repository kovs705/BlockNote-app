//
//  VC+Ext.swift
//  BlockNote app
//
//  Created by Kovs on 01.02.2023.
//

import UIKit
import CoreData
import SpriteKit

// I have problems with xcode and cant commit 

class C1NavViewExt: UIViewController {
    var groups: [NSManagedObject] = []
    var hour = Calendar.current.component(.hour, from: Date())
    
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
    
    // MARK: - Sorting func
    func sortGroupsByNumber(_ groups: [GroupType]) -> [GroupType] {
        groups.sorted { groupA, groupB in
            groupA.number < groupB.number
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
        group.setValue((groups.count) + 1, forKey: Keys.gNumber)
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
