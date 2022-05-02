//
//  C1NoteView.swift
//  BlockNote app
//
//  Created by Kovs on 17.03.2022.
//

import CoreData
import UIKit

class C1NoteView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout
    lazy var note = Note()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topNoteName: UITextView!
    @IBOutlet weak var blockCollectionView: UICollectionView!
    
    var noteItemArray_Sorted: [NoteItem] = []
    
    // blockTypes:
    let textBlock = "TextBlock"
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBlockUIB = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        
        self.navigationItem.rightBarButtonItem = addBlockUIB
        
        // Navigation and ScrollView
        title = note.wrappedNoteName
        scrollView.alwaysBounceVertical = true
        
        // Sorting and other stuff
        noteItemArray_Sorted = note.noteItemArray.sorted { $0.noteItemOrder < $1.noteItemOrder }
        
        // UICollectionView
        blockCollectionView.register(UINib(nibName: "TextBlock", bundle: nil), forCellWithReuseIdentifier: textBlock)
        
        blockCollectionView.allowsSelection = true
        blockCollectionView.dataSource      = self
        blockCollectionView.delegate        = self
        
        // debug
        print("\(noteItemArray_Sorted.count)")
        
        
    }
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        noteItemArray_Sorted.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let noteItem = noteItemArray_Sorted[indexPath.row]
        
        if noteItem.noteItemType == textBlock {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textBlock, for: indexPath) as! TextBlock
            cell.contentView.translatesAutoresizingMaskIntoConstraints = false
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textBlock, for: indexPath) as! TextBlock
            cell.contentView.translatesAutoresizingMaskIntoConstraints = false
            return cell
        }
    }
    
    // MARK: - sizing for blocks
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            <#code#>
//        }
    
    
    
    
    // MARK: - Add block
    @objc func addBlock() {
        let alert = UIAlertController(title: "New block", message: "Enter some text for block", preferredStyle: .alert)
        
        // save action button
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard
                let textField = alert.textFields?.first,
                let blockToSave = textField.text
            else {
                return
            }
            
            self.save(blockType: textBlock, blockText: blockToSave)
            // self.groupCollection.reloadData()
        }
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        
    }
    // MARK: - Save block
    func save(blockType: String, blockText: String) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        let managedContext =
        appDelegate.persistentContainerOffline.viewContext
        
        let entity =
        NSEntityDescription.entity(forEntityName: "NoteItem",
                                   in: managedContext)!
        
        let blockItem = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        
        blockItem.setValue(blockType, forKey: "noteItemType")
        blockItem.setValue(blockText, forKey: "noteItemText")
        
        do {
            // note.noteItemArray.insert(blockItem, at: 0)
            note.addObject(value: blockItem, forKey: "noteItems")

            print("Successfully added")
            try managedContext.save()
            
            blockCollectionView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Delete block
    
    
}

/*
 To continue I need to know what type of cells user will have
    taskBlock - list of tasks
    vocabularyBlock - show the translation by clicking on word
    mapBlock - attach some coordinates on map (share - open in Google Maps)
 TextBlock  <------ in progress
    ImageBlock
 ======================
 make a grey colored loading on the upper right corner
 */


