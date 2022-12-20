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
        
        sortArray()
        // noteArraySorted = groupType.typesOfNoteArray.sorted(by: { $0.noteID < $1.noteID })
        
        
        
        setupDetailVC()
    }
    
    // MARK: - IBActions
    @IBAction func addNoteButton(sender: UIButton!) {
        addNote()
    }
    
    @IBAction func deleteGroup(_ sender: UIButton) {
        deleteGroup(groupName: self.groupType.wrappedGroupName)
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
    
    // MARK: - Sort func
    func sortArray() {
        noteArraySorted = groupType.typesOfNoteArray.sorted {
            $0.noteID < $1.noteID
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
    
    // MARK: - Segue to the blocks
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.isUserInteractionEnabled = true
        }
        performSegue(withIdentifier: "noteDetail", sender: indexPath)
        collectionView.isUserInteractionEnabled = false
    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        collectionView.reloadItems(at: [indexPath])
//        collectionView.deselectItem(at: indexPath, animated: true)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteDetail" {
            if let destination = segue.destination as? C1NoteDetailTBC,
               let noteIndex = noteListCollection.indexPathsForSelectedItems?.first {
                destination.note = self.noteArraySorted[noteIndex.row]
            }
        } else if segue.identifier == "agenda" {
            if let destination = segue.destination as? AgendaVC,
               let noteIndex = noteListCollection.indexPathsForSelectedItems?.first {
                destination.note = self.noteArraySorted[noteIndex.row]
            }
        }
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        noteListCollection.reloadData()
    }
    
    // MARK: - Setup UI
    func setupDetailVC() {
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
                sortArray()
                self.noteListCollection.performBatchUpdates({
                    self.noteListCollection.insertItems(at: [IndexPath(item: noteArraySorted.count - 1, section: 0)])
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
