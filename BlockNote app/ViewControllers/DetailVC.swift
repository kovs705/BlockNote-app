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
    
    //TODO: first sort important on top, then sort by order
}

class DetailVC: DetailVCExt {
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

    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = groupType.groupName ?? "Unknown"
        
        sortArray()
        // noteArraySorted = groupType.typesOfNoteArray.sorted(by: { $0.noteID < $1.noteID })
        
        setupDetailVC(scrollView: scrollView, noteListCollection: noteListCollection, numberOfNotesLabel: numberOfNotesLabel, topBar: topBar, first_column: first_column, second_column: second_column, third_column: third_column)
    }
    
    // MARK: - IBActions
    @IBAction func addNoteButton(sender: UIButton!) {
        addNote()
    }
    
    @IBAction func deleteGroup(_ sender: UIButton) {
        deleteGroup(groupName: self.groupType.wrappedGroupName)
    }
    
}

// MARK: - UICollectinView extensions
extension DetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // groupType.typesOfNoteArray.count
        noteArraySorted.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let noteCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.noteViewCell, for: indexPath) as! NoteViewCell
        
    // configuring cell
        // noteCell.setNoteName(name: groupType.typesOfNoteArray[indexPath.row].value(forKey: "noteName") as! String)
        noteCell.setNoteName(name: noteArraySorted[indexPath.row].value(forKey: Keys.nName) as! String)
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
        performSegue(withIdentifier: Cells.noteDetail, sender: indexPath)
        collectionView.isUserInteractionEnabled = false
    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        collectionView.reloadItems(at: [indexPath])
//        collectionView.deselectItem(at: indexPath, animated: true)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteDetail" {
            if let destination = segue.destination as? C2NoteDetailTBC,
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
    
    // MARK: - Alert with textField to add the note
    @objc func addNote() {
        let alert = UIAlertController(title: "New Note", message: "Enter a name for the note", preferredStyle: .alert)
        
        // save button
        let saveNoteButton = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            guard
                let textField = alert.textFields?.first,
                let noteToSave = textField.text
            else {
                print("Note has not been saved")
                return
            }
            // save action:
            self.saveNote(noteName: noteToSave, noteListCollection: self.noteListCollection) // -----------> Check this
            
        }
        // cancel button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveNoteButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
    // MARK: - Accept the warning and open the alert again
    func acceptAttention() {
        let attentionAlert = UIAlertController(title: "Enter note name", message: "Type something in field", preferredStyle: .alert)
        
        let acceptButton = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.addNote()
        }
        
        attentionAlert.addAction(acceptButton)
        present(attentionAlert, animated: true)
    }
    
}
