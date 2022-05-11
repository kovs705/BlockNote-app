//
//  C1NoteView.swift
//  BlockNote app
//
//  Created by Kovs on 17.03.2022.
//

import CoreData
import UIKit

// class C1NoteView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
class C1NoteView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // UICollectionViewDelegateFlowLayout
    lazy var note = Note()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topNoteName: UITextView!
    // @IBOutlet weak var blockCollectionView: UICollectionView!
    @IBOutlet weak var blockUITableView: UITableView!
    
    var noteItemArray_Sorted: [NoteItem] = []
    
    // blockTypes:
    let textBlock = "TextBlock"
    
    // dynamic height of blockCells:
//    var layout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        let width = UIScreen.main.bounds.size.width
//        layout.estimatedItemSize = CGSize(width: width, height: 10)
//        return layout
//    }()
    
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
        
        // UITableView
        blockUITableView.delegate = self
        blockUITableView.dataSource = self
        
        
        // UICollectionView
        // blockCollectionView.register(UINib(nibName: "TextBlock", bundle: nil), forCellWithReuseIdentifier: textBlock)
//        blockCollectionView?.collectionViewLayout = layout
//
//        blockCollectionView.allowsSelection = true
//        blockCollectionView.dataSource      = self
//        blockCollectionView.delegate        = self
        
        // debug
        print("\(noteItemArray_Sorted.count)")
        
        
    }
    
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteItemArray_Sorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteItem = noteItemArray_Sorted[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textBlock, for: indexPath) as! TVTextBlock
        
        cell.textChanged { [weak tableView] (newText: String) in
            noteItem.noteItemText = newText
            
            DispatchQueue.main.async {
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
        }
        return cell
    }
    
    // MARK: - UICollectionView
    /*
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteItemArray_Sorted.count
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let basicHeight: CGFloat = 100
        let width = blockCollectionView.safeAreaLayoutGuide.layoutFrame.width
        - sectionInset.left
        - sectionInset.right
        - blockCollectionView.contentInset.left
        - blockCollectionView.contentInset.right
        
        return CGSize(width: width, height: basicHeight)
        
    }
    */
    
    
    
    // MARK: - Add block
    @objc func addBlock() {
        let alert = UIAlertController(title: "New block", message: "Enter some text for block", preferredStyle: .alert)
        
        // save action button
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
//            guard
//                // let textField = alert.textFields?.first,
//                // let blockToSave = textField.text
//            else {
//                return
//            }
            let blockToSave = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            
            self.save(blockType: textBlock, blockText: blockToSave)
            // self.groupCollection.reloadData()
        }
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // alert.addTextField()
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
            
            //blockCollectionView.reloadData()
            blockUITableView.reloadData()
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


