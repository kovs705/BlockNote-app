//
//  C3NoteDetailPresenter.swift
//  BlockNote app
//
//  Created by Kovs on 15.07.2023.
//

import Foundation
import CoreData
import UIKit

protocol C3NoteDetailViewProtocol: AnyObject {
    // prop
    var note: Note { get set }
    var noteItemArray_sorted: [NoteItem] { get set }
    var deletingBlocksOrder: Int { get set }
    
    var imagePicker: UIImagePickerController! { get }
    var isLargeHidden: Bool { get set }
    
    var textForTextlock: String { get set }
    
    var indexOfBlock: Int { get set }
    var baseImage: UIImage { get }
    
    
    // func
    func beginEndUpdates()
    func performBatchUpdates(at insertRow: Int)
    func performDeleteUpdates(at deleteRow: Int)
}

protocol C3NoteDetailPresenterProtocol: AnyObject {
    
    init(view: C3NoteDetailViewProtocol, persistenceBC: PersistenceBlockController)
    
    /// Func to create a new textBlock by clicking on return button + make the last block (this text block) as a first responder and start typing there:
     func saveAndStartTyping()
    
    /// Gets the text everytime user changes text in block
    func getText(text: String?, noteListTB: UITableView)
    
    /// Sort and update
    func sortAndUpdate()
    
    /// Save block
    func save(blockType: String, theCase: BlockCases, pickedImage: UIImage?)
    
    /// Reorder
    func reorder(for value: NSManagedObject, using managedContext: NSManagedObjectContext)
    
    /// Delete block
    func deleteblock(noteListTB: UITableView, at indexPath: IndexPath)
    
    // Persistence funcs:
    func delegateSave()
}

final class C3NoteDetailPresenter: C3NoteDetailPresenterProtocol {
    
    weak var view: C3NoteDetailViewProtocol?
    weak var persistenceBC: PersistenceBlockController?
    
    required init(view: C3NoteDetailViewProtocol, persistenceBC: PersistenceBlockController) {
        self.view = view
        self.persistenceBC = persistenceBC
    }
    
    // MARK: - Persistence funcs
    func delegateSave() {
        persistenceBC?.delegateSave()
    }
    
    // MARK: - Other funcs
    func saveAndStartTyping() {
        print("You tapped return button on keyboard")           // check with print func
        save(blockType: Block.textBlock, theCase: .text, pickedImage: nil)
        self.view?.beginEndUpdates()
    }
    
    func getText(text: String?, noteListTB: UITableView) {
        guard let view = self.view else { return }
        
        self.view?.textForTextlock = text ?? "Nothing in the text, or it's just the bug."
        persistenceBC?.update(blockText: view.textForTextlock, block: view.noteItemArray_sorted[view.indexOfBlock], noteListTB: noteListTB)
        // print("you changed the block with the index of \(indexOfBlock)")
    }
    
    func sortAndUpdate() {
        guard let note = self.view?.note else { return }
        
        /// made for reuse multiple times to update sorted array of
        //TODO: make a switch for other objects in CoreData, (make a reusable public func)
        self.view?.noteItemArray_sorted = note.noteItemArray.sorted {
            $0.noteItemOrder < $1.noteItemOrder
        }
        // noteListTB.reloadData()
        // noteListTB.endEditing(true)
        print("=========\nNumber of blocks: \(self.view?.noteItemArray_sorted.count)")
    }
    
    func save(blockType: String, theCase: BlockCases, pickedImage: UIImage?) {
        
        guard let noteItemArray_sorted = self.view?.noteItemArray_sorted else { return }
        
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
            persistenceBC?.setValues(for: blockItem, from: theCase, pickedImage: pickedImage)
        } else {
            persistenceBC?.setValues(for: blockItem, from: theCase, pickedImage: nil)
        }
        
        blockItem.setValue(Date(), forKey: Keys.niLastChanged)
        
        // MARK: - Give an order number for note:
        if noteItemArray_sorted.isEmpty {
            blockItem.setValue(1, forKey: Keys.niOrder)
        } else {
            blockItem.setValue(noteItemArray_sorted.count + 1, forKey: Keys.niOrder)
        }
        
        reorder(for: blockItem, using: managedContext)
    }
    
    func reorder(for value: NSManagedObject, using managedContext: NSManagedObjectContext) {
        guard let note = self.view?.note else { return }
        guard let noteItemArray_sorted = self.view?.noteItemArray_sorted else { return }
        
        do {
            note.addObject(value: value, forKey: Keys.nItems)
            
            if managedContext.hasChanges {
                sortAndUpdate()
                try managedContext.save()
            } else {
                print("Something wrong on saving block")
                return
            }
            
            // check for changes in sorted array:
            if note.noteItems?.count == noteItemArray_sorted.count {
                
                self.view?.performBatchUpdates(at: noteItemArray_sorted.count)
                
            } else {
                sortAndUpdate()
                print("notes: \(note.noteItems?.count ?? 0) === sortedNotes: \(noteItemArray_sorted.count)")
                
                self.view?.beginEndUpdates()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteblock(noteListTB: UITableView, at indexPath: IndexPath) {
        guard let view = self.view else { return }
        guard let note = self.view?.note else { return }
        guard let noteItemArray_sorted = self.view?.noteItemArray_sorted else { return }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainerOffline.viewContext
        
        view.deletingBlocksOrder = indexPath.row + 1
        
        note.removeObject(value: noteItemArray_sorted[indexPath.row], forKey: Keys.nItems)
        
        for block in noteItemArray_sorted {
            if block.value(forKey: Keys.niOrder) as! Int >= view.deletingBlocksOrder {
                let value = block.value(forKey: Keys.niOrder) as! Int - 1
                block.setValue(value, forKey: Keys.niOrder)
            }
        }
        
        sortAndUpdate()
        
        do {
            if managedContext.hasChanges {
                try managedContext.save()
                view.performDeleteUpdates(at: view.deletingBlocksOrder)
            }
        } catch {
            print("Something wrong on deleting the block")
        }
    }
}
