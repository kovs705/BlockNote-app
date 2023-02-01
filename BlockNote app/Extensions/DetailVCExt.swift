//
//  DetailVCExt.swift
//  BlockNote app
//
//  Created by Kovs on 01.02.2023.
//

import UIKit
import CoreData

class DetailVCExt: UIViewController {
    lazy var groupType = GroupType()
    lazy var noteObject = Note()
    
    var noteArraySorted: [Note] = [Note]()
    var delegate: detail_vc_Delegate?
    
    // MARK: - Sort func
    func sortArray() {
        noteArraySorted = groupType.typesOfNoteArray.sorted {
            $0.noteID < $1.noteID
        }
    }
    
    // MARK: - Delete func
    func deleteGroup(groupName: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext       = appDelegate.persistentContainerOffline.viewContext
        
        if groupType.wrappedGroupName == groupName {
            
            if !self.groupType.typesOfNoteArray.isEmpty {
                
                for note in self.groupType.typesOfNoteArray {
                    viewContext.delete(note)
                }
            } else {
                print("No notes in array")
            }
            
            viewContext.delete(self.groupType)
            
            do {
                try viewContext.save()
                _ = navigationController?.popViewController(animated: true)
                delegate?.closeAndDelete()
            } catch {
                print("Something went wrong while deleting the group and note!!")
            }
        } else {
            print("Something wrong on checking the name of the group!")
        }
    }
    
    // MARK: - Setup UI
    func setupDetailVC(scrollView: UIScrollView, noteListCollection: UICollectionView, numberOfNotesLabel: UILabel, topBar: UIView, first_column: UIStackView, second_column: UIStackView, third_column: UIStackView) {
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        
        // noteListCollection.backgroundColor = UIColor(named: "BackWhite")
        noteListCollection.register(UINib(nibName: "NoteViewCell", bundle: nil), forCellWithReuseIdentifier: "NoteViewCell")
        noteListCollection.allowsSelection = true
        noteListCollection.allowsMultipleSelection = true
        
        numberOfNotesLabel.text = "\(groupType.typesOfNoteArray.count)"
        
        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.masksToBounds = false
        
        topBar.layer.cornerRadius = 20
        topBar.shadowOffset = CGSize(width: 5, height: 0)
        topBar.layer.shadowRadius = 10
        topBar.shadowOpacity = 0.3
        topBar.layer.shadowPath = CGPath(rect: topBar.bounds, transform: nil)
        
        topBar.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
        
        first_column.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
        second_column.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
        third_column.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
    }
    
    
    // MARK: - Save the note to the group from the Adding alert
    func saveNote(noteName: String, noteListCollection: UICollectionView) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // use viewContext to save changes:
        let viewContext = appDelegate.persistentContainerOffline.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: viewContext)!
        
        let note = NSManagedObject(entity: entity, insertInto: viewContext)
        
        if groupType.wrappedGroupName == "" {
            note.setValue("Unknown group", forKey: Keys.nType)
        } else {
            note.setValue(self.groupType.wrappedGroupName, forKey: Keys.nType)
        }
        
        if groupType.typesOfNoteArray.isEmpty {
            note.setValue(1, forKey: Keys.nID)
        } else {
            note.setValue((groupType.typesOfNoteArray.last?.noteID ?? 0) + 1, forKey: Keys.nID)
            print("\((groupType.typesOfNoteArray.count) + 1) note added already")
        }
        
        note.setValue("Test level", forKey: Keys.nLevel)
        
        if noteName == "" || noteName.isEmpty {
            DetailVC().acceptAttention()
            return
        } else {
            note.setValue(noteName, forKey: Keys.nName)
        }
        // Append the note to the group:
        do {
            // adding object
            self.groupType.addObject(value: note, forKey: Keys.noteTypes)
            // saving changes
            
            if self.groupType.hasChanges {
                sortArray()
                noteListCollection.performBatchUpdates({
                    noteListCollection.insertItems(at: [IndexPath(item: noteArraySorted.count - 1, section: 0)])
                }, completion: nil)
                try viewContext.save()
            } else {
                print("Something wrong on saving note. No changes? No bitches?")
            }
            
            
            
        } catch let error as NSError {
            print("Could not save and add note. \(error), \(error.userInfo)")
        }
        
        //        noteName  noteLevel   noteType    noteItems   noteIsMarked
        //        typeOfNote    wrappedNoteType     wrappedNoteName     noteItemArray
    }
}
