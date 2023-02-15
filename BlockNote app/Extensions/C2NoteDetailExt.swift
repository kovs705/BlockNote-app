//
//  C2NoteDetailExt.swift
//  BlockNote app
//
//  Created by Kovs on 08.02.2023.
//

import UIKit
import CoreData

class C2NoteDetailExt: UIViewController {
    // MARK: - Properties
    lazy var note = Note()
    var noteItemArray_sorted: [NoteItem] = []
    
    var imagePicker: UIImagePickerController!
    var isLargeHidden = false
    
    var textForTextlock: String = ""
    
    var indexOfBlock = 0
    let baseImage = UIImage(named: "gav")!
    
    let addBlockButton = dockButton(fontSize: 20, icon: Icons.addGroup, color: .systemGray4)
    let textDockButton = dockTextButton(frame: .zero)
    
    
    // MARK: - UI part
    let padding: CGFloat = 10
    
    lazy var contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .horizontal
        contentView.distribution = .fill
        contentView.spacing = 10
        contentView.backgroundColor = .systemGray6
        
        return contentView
    }()
    
    lazy var dock: UIView = {
       let dock = UIView()
        dock.backgroundColor = .systemGray6
        dock.translatesAutoresizingMaskIntoConstraints = false
        return dock
    }()
    
    func configureDock() {
        view.addSubview(dock)
        
        NSLayoutConstraint.activate([
            dock.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dock.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dock.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dock.widthAnchor.constraint(equalToConstant: view.bounds.width),
            dock.heightAnchor.constraint(equalToConstant: 80)
            
        ])
        
        // placing contentView - UIStackView
        dock.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: dock.topAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: dock.leadingAnchor, constant: padding*2),
            contentView.trailingAnchor.constraint(equalTo: dock.trailingAnchor, constant: -(padding*2)),
            contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // placing text buttons:
        contentView.addArrangedSubview(addBlockButton)
        contentView.addArrangedSubview(textDockButton)
    }
    
    
    
    
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
    
    func delegateSave() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainerOffline.viewContext
        
        do {
            if managedContext.hasChanges {
                try managedContext.save()
            } else {
                print("Wrong on updating the note item")
            }
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
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
                    noteListTB.endUpdates()
                }
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
