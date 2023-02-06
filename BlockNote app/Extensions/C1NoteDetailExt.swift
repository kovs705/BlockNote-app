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
    
    func setValues(for block: NSManagedObject, from type: BlockCases, pickedImage: UIImage?) {
        switch type {
        case .title:
            block.setValue(Block.titleBlock, forKey: Keys.niType)
            block.setValue(Block.titleToSave, forKey: Keys.niText)
        case .text:
            block.setValue(Block.textBlock, forKey: Keys.niType)
            block.setValue(Block.blockToSave, forKey: Keys.niText)
        case .photo:
            block.setValue(Block.photoBlock, forKey: Keys.niType)
            block.setValue(pickedImage?.toData as NSData?, forKey: Keys.niPhoto)
        case .space:
            block.setValue(Block.spaceBlock, forKey: Keys.niType)
        }

    }
    
    
    // MARK: - Save block
    func save(blockType: String, theCase: BlockCases, noteListTB: UITableView, pickedImage: UIImage?) {
        
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
        if theCase == .photo {
            setValues(for: blockItem, from: theCase, pickedImage: pickedImage)
        } else {
            setValues(for: blockItem, from: theCase, pickedImage: nil)
        }
        
        blockItem.setValue(Date(), forKey: Keys.niLastChanged)
        
        // MARK: - Give an order number for note:
        if noteItemArray_sorted.isEmpty {
            blockItem.setValue(1, forKey: Keys.niOrder)
        } else {
            blockItem.setValue(noteItemArray_sorted.count + 1, forKey: Keys.niOrder)
        }
        
        reorder(for: blockItem, in: noteListTB, using: managedContext)
        
    }
    
    
    func reorder(for value: NSManagedObject, in noteListTB: UITableView, using managedContext: NSManagedObjectContext) {
        do {
            note.addObject(value: value, forKey: Keys.nItems)
            
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
