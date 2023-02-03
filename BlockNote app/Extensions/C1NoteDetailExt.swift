//
//  C1NoteDetailExt.swift
//  BlockNote app
//
//  Created by Kovs on 01.02.2023.
//

import UIKit
import CoreData

class C1NoteDetailExt: UITableViewController {
    // MARK: - Properties
    lazy var note = Note()
    lazy var textView = UITextView()
    var noteItemArray_sorted: [NoteItem] = []
    
    var imagePicker: UIImagePickerController!
    var isLargeHidden = false
    
    var textForTextlock: String = ""
    
    var indexOfBlock = 0
    let baseImage = UIImage(named: "gav")!
    
    
    // MARK: - Sort and update
    func sortAndUpdate() {
        /// made for reuse multiple times to update sorted array of
        //TODO: make a switch for other objects in CoreData, (make a reusable public func)
        noteItemArray_sorted = note.noteItemArray.sorted {
            $0.noteItemOrder < $1.noteItemOrder
        }
        // noteListTB.reloadData()
        // noteListTB.endEditing(true)
        print("=========\nNumber of blocks: \(noteItemArray_sorted.count)")
    }
    
    

    
    
    // MARK: - Save block
    func save(blockType: String, blockText: String, noteListTB: UITableView) {
        // var newNumberOfNotes = 0
        
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
        
        blockItem.setValue(blockType, forKey: Keys.niType)
        blockItem.setValue(blockText, forKey: Keys.niText)
        blockItem.setValue(Date(), forKey: Keys.niLastChanged)
        
        // MARK: - Give an order number for note:
        if noteItemArray_sorted.isEmpty {
            blockItem.setValue(1, forKey: Keys.niOrder)
        } else {
            blockItem.setValue(noteItemArray_sorted.count + 1, forKey: Keys.niOrder)
//            if note.noteItemArray.last?.noteItemType == photoBlock {
//                noteListTB.reloadData()
//                noteItemArray_sorted
//            }
        }
        
        do {
            
            note.addObject(value: blockItem, forKey: Keys.nItems)
            
            if managedContext.hasChanges {
                sortAndUpdate()
                try managedContext.save()
            } else {
                print("Something wrong on saving block. No changes? No bitches?")
            }
            
            // check for changes in sorted array:
            if note.noteItems?.count == noteItemArray_sorted.count {
                
                noteListTB.performBatchUpdates({
                    noteListTB.insertRows(at: [IndexPath(row: noteItemArray_sorted.count - 1, section: 0)], with: .automatic)
                }, completion: nil)
                
                DispatchQueue.main.async {
                    noteListTB.beginUpdates()
                    noteListTB.endUpdates()
                }
            } else {
                sortAndUpdate()
                print("notes: \(note.noteItems?.count ?? 0) === sortedNotes: \(noteItemArray_sorted.count)")
                
                DispatchQueue.main.async {
                    noteListTB.beginUpdates()
                    // noteListTB.reloadRows(at: [indexPath], with: .automatic)
                    noteListTB.endUpdates()
                }
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
