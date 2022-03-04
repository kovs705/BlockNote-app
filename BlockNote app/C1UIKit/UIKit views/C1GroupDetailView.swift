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
// import simd

//public class VM: ObservableObject {
//    @Published public var alertBool: Bool = false
//}

class C1GroupDetailView: UIViewController, UITableViewDataSource {
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupType.typesOfNoteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteObject", for: indexPath)
        cell.textLabel?.text = groupType.typesOfNoteArray[indexPath.row].wrappedNoteName
        return cell
    }
    
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) -> UITableViewCell {
//
//    }
    
    
    // MARK: - Properties
    var groupType = GroupType()
//    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
//    lazy var UIBarSize = CGSize(width: self.view.frame.width, height: 150)
    
    // MARK: - Views and buttons
    lazy var scrollView           = UIScrollView()
    lazy var containerSwiftUIView = UIView()
    lazy var listOfNotes          = UIStackView()
    lazy var notesTableView       = UITableView()
    
    // groupType.noteTypes?.sorted(by: { $0.noteID > $1.noteID })
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - TableView
        notesTableView.dataSource = self
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteObject")
        
        title = groupType.groupName ?? "Unknown"
        self.view.backgroundColor = .white
        
        
        // let rightAddButtonForTableView = UIBarButtonItem    <----- work on it after TableView setup
        
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
        notesTableView.backgroundColor = .black
        
        notesTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(scrollView.snp.width).offset(-40)
            make.top.equalTo(containerSwiftUIView.snp.bottom).offset(20)
            // make.height.equalTo(300)
            if !groupType.typesOfNoteArray.isEmpty {
                make.height.equalTo(groupType.typesOfNoteArray.count * 50)
            } else {
                print("Nothing in UITableView")
                #warning("Place some text underneath the UITableView")
            }
            make.left.equalToSuperview().offset(20)
        }
        
        
        // MARK: - StackView
        // scrollView.addSubview(listOfNotes)
//        listOfNotes.backgroundColor = .black
//
//        listOfNotes.axis            = .vertical
//        listOfNotes.distribution    = .equalSpacing
//        listOfNotes.spacing         = 10
//
//        listOfNotes.snp.makeConstraints { (make) -> Void in
//            make.width.equalToSuperview().offset(-40)
//            make.top.equalTo(containerSwiftUIView.snp.bottom).offset(20)
//            #warning("Work on dynamic height")
//            make.height.equalTo(300)
//            make.left.equalToSuperview().offset(20)
//        }
        //                                                      addNotesToTheNoteList()
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
        
        note.setValue("Test level", forKey: "noteLevel")
        
        if noteName == "" {
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
                    make.height.equalTo(groupType.typesOfNoteArray.count * 50)
                } else {
                    print("Nothing in UITableView")
                }
                make.left.equalToSuperview().offset(20)
            }
            self.notesTableView.layoutIfNeeded()
            self.notesTableView.reloadData()
            
            // for UIStackView:
//            for noteObject in groupType.typesOfNoteArray {
//                if noteObject.wrappedNoteName == noteName {
//                let noteItem = noteListObject()
//                    noteItem.setTitle("\(noteName)", for: .normal)
//                    listOfNotes.addArrangedSubview(noteItem)
//                }
//            }
            
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
    
//    public func VMdo() {
//        if viewModel.alertBool == true {
//            addNote()
//            viewModel.alertBool = false
//        }
//    }
    
}


    
//    lazy var loremIpsumLabel: UILabel = {
//       let text = UILabel()
//        text.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
//        text.numberOfLines = 0
//        text.sizeToFit()
//        text.textAlignment = .center
//        text.textColor = UIColor.black
//        text.translatesAutoresizingMaskIntoConstraints = false
//        return text
//    }()
