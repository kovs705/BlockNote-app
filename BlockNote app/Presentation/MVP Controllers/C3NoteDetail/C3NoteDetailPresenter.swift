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

    var imagePicker: UIImagePickerController! { get }

    var textForTextlock: String { get set }

    /// updates dynamically when user interacts with blocks with text (default should be the last)
    var indexOfBlock: Int { get set }

    // func
    func beginEndUpdates()
    func performBatchUpdates(at insertRow: Int)
    func performDeleteUpdates(at deleteRow: Int)
    
    /// Func to start typing on the new row in the new text block (if it's a textblock)
    func startTyping(from row: Int)
}

protocol C3NoteDetailPresenterProtocol: AnyObject {

    var note: Note? { get set }
    var deletingBlocksOrder: Int { get set }

    var noteItemArray_sorted: [NoteItem] { get set }

    var managedContext: NSManagedObjectContext { get }

    init(view: C3NoteDetailViewProtocol, persistenceBC: PersistenceBlockController, note: Note)

    /// Gets the text everytime user changes text in block
    func getText(text: String?, noteListTB: UITableView)

    /// Sort and update
    func sortAndUpdate()

    /// Save block
    func save(blockType: String, theCase: BlockCases, pickedImage: UIImage?, at index: Int)

    /// Reorder
    func reorder(for value: NSManagedObject, using managedContext: NSManagedObjectContext)

    /// Delete block
    func deleteblock(noteListTB: UITableView, at indexPath: IndexPath)

    /// Persistence funcs:
    func delegateSave()
    
    /// update indexesafter creating a new block in the middle
    func updateIndexes(from index: Int)
}

final class C3NoteDetailPresenter: C3NoteDetailPresenterProtocol {

    var note: Note?
    var deletingBlocksOrder: Int = 0

    var noteItemArray_sorted: [NoteItem] = []

    weak var view: C3NoteDetailViewProtocol?
    var persistenceBC: PersistenceBlockController?

    var managedContext: NSManagedObjectContext

    required init(view: C3NoteDetailViewProtocol, persistenceBC: PersistenceBlockController, note: Note) {
        self.view = view
        self.persistenceBC = persistenceBC
        self.note = note

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.managedContext = appDelegate.persistentContainerOffline.viewContext
        } else {
            self.managedContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        }
    }

    // MARK: - Persistence funcs
    func delegateSave() {
        persistenceBC?.delegateSave()
    }

    // MARK: - Get text
    func getText(text: String?, noteListTB: UITableView) {
        guard let view = self.view else { return }

        self.view?.textForTextlock = text ?? "Nothing in the text, or it's just the bug."
        persistenceBC?.update(blockText: view.textForTextlock, block: noteItemArray_sorted[view.indexOfBlock], noteListTB: noteListTB)
        // print("you changed the block with the index of \(indexOfBlock)")
    }

    // MARK: - Sort&Update
    func sortAndUpdate() {
        guard let note = note else { return }
        noteItemArray_sorted = note.noteItemArray.sorted {
            $0.noteItemOrder < $1.noteItemOrder
        }
    }

    // MARK: - Save
    func save(blockType: String, theCase: BlockCases, pickedImage: UIImage?, at index: Int) {
        guard let persistenceBC = self.persistenceBC else { return }

        let entity = NSEntityDescription.entity(forEntityName: "NoteItem", in: managedContext)!

        let blockItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        persistenceBC.setValues(for: blockItem, from: theCase, pickedImage: theCase == .photo ? pickedImage : nil, at: index)
        
        updateIndexes(from: index)
        reorder(for: blockItem, using: managedContext)
    }

    func reorder(for value: NSManagedObject, using managedContext: NSManagedObjectContext) {
        guard let view = self.view else { return }
        guard let note = note else { return }

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
                view.performBatchUpdates(at: noteItemArray_sorted.count - 1)
            } else {
                sortAndUpdate()
                view.beginEndUpdates()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func deleteblock(noteListTB: UITableView, at indexPath: IndexPath) {
        guard let view = self.view else { return }
        guard let note = note else { return }

        deletingBlocksOrder = indexPath.row + 1

        note.removeObject(value: noteItemArray_sorted[indexPath.row], forKey: Keys.nItems)

        for block in noteItemArray_sorted {
            if block.value(forKey: Keys.niOrder) as! Int >= deletingBlocksOrder {
                let value = block.value(forKey: Keys.niOrder) as! Int - 1
                block.setValue(value, forKey: Keys.niOrder)
            }
        }

        sortAndUpdate()

        do {
            if managedContext.hasChanges {
                try managedContext.save()
                view.performDeleteUpdates(at: deletingBlocksOrder)
            }
        } catch {
            print("Something wrong on deleting the block")
        }
    }
    
    func updateIndexes(from index: Int) {
        if noteItemArray_sorted.isEmpty { return }
        
        for block in noteItemArray_sorted {
            if block.value(forKey: Keys.niOrder) as! Int >= index {
                print("its more than \(block.value(forKey: Keys.niOrder) as! Int)")
                let value = block.value(forKey: Keys.niOrder) as! Int + 1
                block.setValue(value, forKey: Keys.niOrder)
            }
        }
    }
    
}
