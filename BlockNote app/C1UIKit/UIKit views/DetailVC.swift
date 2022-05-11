//
//  DetailVCViewController.swift
//  BlockNote app
//
//  Created by Kovs on 25.03.2022.
//

import UIKit
import CoreData
import SwiftUI

protocol detail_vc_Delegate {
    func deleteAndUpdate()
    func closeAndDelete()
}

class DetailVC: UIViewController {
// main:
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteListCollection: UICollectionView!
// design and color:
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var first_column: UIStackView!
    @IBOutlet weak var second_column: UIStackView!
    @IBOutlet weak var third_column: UIStackView!
    
// numbers and notes:
    @IBOutlet weak var numberOfNotesLabel: UILabel!
    @IBOutlet weak var importantNotesLabel: UILabel!
    
// properties
    lazy var groupType = GroupType()
    lazy var noteObject = Note()
    
    var noteArraySorted: [Note] = [Note]() // sorted note array
    
// segue
    let segueToNoteView = "noteDetail"
// CoreData properties
    let noteName = "noteName"
    let noteID = "noteID"
    let noteLevel = "noteLevel"
    let noteIsMarked = "noteIsMarked"
    
    var delegate: detail_vc_Delegate?

    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = groupType.groupName ?? "Unknown"
        
        noteArraySorted = groupType.typesOfNoteArray.sorted(by: { $0.noteID < $1.noteID })
        
        setupDetailVC()
    }
    
    
    @IBAction func addNoteButton(sender: UIButton!) {
        addNote()
    }
    
    @IBAction func deleteGroup(_ sender: UIButton) {
        deleteGroup(groupName: self.groupType.wrappedGroupName)
    }
    
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
    
}

// MARK: - UICollectinView
extension DetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // groupType.typesOfNoteArray.count
        noteArraySorted.count
    }
    
    /// 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let noteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteViewCell", for: indexPath) as! NoteViewCell
        
    // configuring cell
        // noteCell.setNoteName(name: groupType.typesOfNoteArray[indexPath.row].value(forKey: "noteName") as! String)
        noteCell.setNoteName(name: noteArraySorted[indexPath.row].value(forKey: "noteName") as! String)
        noteCell.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return noteCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width-4)/1, height: 50)
    }
    
    // MARK: - Segue to the
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "noteDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? C1NoteView,
//           let noteIndex = noteListCollection.indexPathsForSelectedItems?.first {
//            destination.note = self.noteArraySorted[noteIndex.row]
//        }
        if let destination = segue.destination as? C1NoteDetailView,
           let noteIndex = noteListCollection.indexPathsForSelectedItems?.first {
            destination.note = self.noteArraySorted[noteIndex.row]
        }
    }
    
    // MARK: - Setup UI
    func setupDetailVC() {
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        
        noteListCollection.backgroundColor = UIColor(named: "DarkBackground")
        noteListCollection.register(UINib(nibName: "NoteViewCell", bundle: nil), forCellWithReuseIdentifier: "NoteViewCell")
        noteListCollection.allowsSelection = true
        noteListCollection.allowsMultipleSelection = true
        
        numberOfNotesLabel.text = "\(groupType.typesOfNoteArray.count)"
        
        topBar.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
        first_column.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
        second_column.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
        third_column.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
    }
    
    // MARK: - Update UI / Change UI
    //
    //
    //
    //
    
    // MARK: - Alert with textField to add the note
    @objc func addNote() {
        let alert = UIAlertController(title: "New Note", message: "Enter a name for the note", preferredStyle: .alert)
        
        // save button
        let saveNoteButton = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard
                let textField = alert.textFields?.first,
                let noteToSave = textField.text
            else {
                print("Note has not been saved")
                return
            }
            // save action:
            self.saveNote(noteName: noteToSave) // -----------> Check this
            
        }
        // cancel button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveNoteButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
    // MARK: - Save the note to the group from the Adding alert
    func saveNote(noteName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // use viewContext to save changes:
        let viewContext = appDelegate.persistentContainerOffline.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: viewContext)!
        
        let note = NSManagedObject(entity: entity, insertInto: viewContext)
        
        if groupType.wrappedGroupName == "" {
            note.setValue("Unknown group", forKey: "noteType")
        } else {
            note.setValue(self.groupType.wrappedGroupName, forKey: "noteType")
        }
        
        if groupType.typesOfNoteArray.isEmpty {
            note.setValue(1, forKey: "noteID")
        } else {
            note.setValue((groupType.typesOfNoteArray.last?.noteID ?? 0) + 1, forKey: "noteID")
            print("\((groupType.typesOfNoteArray.count) + 1) note added already")
        }
        
        // TODO: When i delete or resort, I should update every note to make sure every note has its own noteID
        
        note.setValue("Test level", forKey: "noteLevel")
        
        if noteName == "" || noteName.isEmpty {
            acceptAttention()
            return
        } else {
            note.setValue(noteName, forKey: "noteName")
        }
        // Append the note to the group:
        do {
            // adding object
            self.groupType.addObject(value: note, forKey: "noteTypes")
            // saving changes
            if self.groupType.hasChanges {
                try viewContext.save()
            } else {
                fatalError("Just testing if something will go wrong, delete it after some time")
            }
                //noteListCollection.reloadData()
            
        } catch let error as NSError {
            print("Could not save and add note. \(error), \(error.userInfo)")
        }
        
        //        noteName  noteLevel   noteType    noteItems   noteIsMarked
        //        typeOfNote    wrappedNoteType     wrappedNoteName     noteItemArray
    }
    
    
    // MARK: - Accept the warning and open the alert again
    func acceptAttention() {
        let attentionAlert = UIAlertController(title: "Enter note name", message: "Type something in field", preferredStyle: .alert)
        
        let acceptButton = UIAlertAction(title: "OK", style: .default) { (action) in
            self.addNote()
        }
        
        attentionAlert.addAction(acceptButton)
        present(attentionAlert, animated: true)
    }
}
