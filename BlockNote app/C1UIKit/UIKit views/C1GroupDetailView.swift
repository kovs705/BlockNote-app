//
//  C1GroupDetailView.swift
//  BlockNote app
//
//  Created by Kovs on 23.01.2022.
//


import UIKit
import CoreData
import SwiftUI
import SnapKit

class C1GroupDetailView: UIViewController, UITableViewDataSource {
    // UIContextMenuInteractionDelegate
    
    // MARK: - Context Menu
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//
//    }
    
    // MARK: - UITableView
    // https://www.youtube.com/watch?v=2Li7OIQb3hQ
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupType.typesOfNoteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteObject", for: indexPath)
        
        cell.textLabel?.text = "\(groupType.typesOfNoteArray[indexPath.row].wrappedNoteName)    \(groupType.typesOfNoteArray[indexPath.row].noteID)"
        cell.textLabel?.textAlignment = .center
        
        cell.backgroundColor = UIColor(named: "DarkBackground")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteObject = groupType.typesOfNoteArray[indexPath.row]
        
        let row = indexPath.row
        
        performSegue(withIdentifier: "showNoteView", sender: row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNoteView" {
            let noteViewC = segue.destination as! C1NoteView
            noteViewC.noteType = noteObject
        }
    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let movedNote = groupType.typesOfNoteArray[sourceIndexPath.row]
//
//        if sourceIndexPath < destinationIndexPath {
//            var startIndex = sourceIndexPath + 1
//        }
//    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Properties
    var groupType = GroupType()
    var noteObject = Note()
    
//    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
//    lazy var UIBarSize = CGSize(width: self.view.frame.width, height: 150)
    
    // MARK: - Views and buttons
    lazy var scrollView           = UIScrollView()
    lazy var containerSwiftUIView = UIView()
    lazy var listOfNotes          = UIStackView()
    lazy var notesTableView       = UITableView()       //  <----- TableView
    
//    var menuAction: UIAction {
//        UIAction(title: "Edit", image: UIImage(systemName: "pencil"), identifier: nil, handler: )
//    }
    
    // groupType.noteTypes?.sorted(by: { $0.noteID > $1.noteID })
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - TableView
        notesTableView.dataSource = self
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteObject")
        
        title = groupType.groupName ?? "Unknown"
        self.view.backgroundColor = .white
        
        // MARK: - Right bar button
        let rightAddButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.addNote))
        
        self.navigationItem.rightBarButtonItem  = rightAddButton
        
        
        // MARK: - ScrollView
        scrollView.bounces                      = true
        // scrollView.isPagingEnabled = true
        scrollView.contentSize                  = CGSize(width: Int(self.view.frame.size.width), height: 100)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize                  = self.view.frame.size
        scrollView.backgroundColor              = UIColor(named: "DarkBackground")
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.bottom.left.right.equalTo(view)
        }
        
        
        // MARK: - ContainerSwiftUIView
        containerSwiftUIView.backgroundColor = UIColor(named: "DarkBackground")
        scrollView.addSubview(containerSwiftUIView)
        
        containerSwiftUIView.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview().offset(-40)
            make.top.equalTo(scrollView.snp.top).offset(10)
            make.height.equalTo(150)
            make.left.equalToSuperview().offset(20)
        }
        setupSwiftUIBar()
        
        
        // MARK: - UITableView
        scrollView.addSubview(notesTableView)
        notesTableView.backgroundColor = UIColor(named: "DarkBackground")
        
        
        notesTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(scrollView.snp.width).offset(-40)
            make.top.equalTo(containerSwiftUIView.snp.bottom).offset(25)
            // make.height.equalTo(300)
            if !groupType.typesOfNoteArray.isEmpty {
                make.height.equalTo(groupType.typesOfNoteArray.count * 50)
            } else {
                print("Nothing in UITableView")
                #warning("Place some text underneath the UITableView")
            }
            make.left.equalToSuperview().offset(20)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSwiftUIBar() {
        let barChildView = UIHostingController(rootView: GroupBar(groupType: groupType))
        addChild(barChildView)
        barChildView.view.frame = containerSwiftUIView.bounds
        containerSwiftUIView.addSubview(barChildView.view)
        barChildView.view.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(containerSwiftUIView)
            make.centerY.equalTo(containerSwiftUIView)
        }
        barChildView.didMove(toParent: self)
    }
    
    func addNotesToTheNoteList() {
        for note in groupType.typesOfNoteArray {
            let noteItem = noteListObject()
            noteItem.setTitle("\(note.wrappedNoteName)", for: .normal)
            listOfNotes.addArrangedSubview(noteItem)
            // listOfNotes.insertArrangedSubview(noteItem, at: 0)
        }
    }
    
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
            
            // updating layout of UITableView with notes:
            
            
            notesTableView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(scrollView.snp.width).offset(-40)
                make.top.equalTo(containerSwiftUIView.snp.bottom).offset(20)
                // make.height.equalTo(300)
                if groupType.typesOfNoteArray != [] {
                    make.height.greaterThanOrEqualTo(groupType.typesOfNoteArray.count * 60)
                } else {
                    print("Nothing in UITableView")
                }
                make.left.equalToSuperview().offset(20)
            }
            self.notesTableView.layoutIfNeeded()
            self.notesTableView.updateConstraints()
            self.notesTableView.reloadData()
            
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
