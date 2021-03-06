//
//  C1NoteDetailView.swift
//  BlockNote app
//
//  Created by Kovs on 13.04.2022.
//

import CoreData
import UIKit
import SnapKit

/*
 To continue I need to know whhat type of cells user will have
    taskBlock - list of tasks
    vocabularyBlock - show the translation by clicking on word
    mapBlock - attach some coordinates on map (share - open in Google Maps)
 TextBlock  <------ in progress
    ImageBlock
 ======================
 make a grey colored loading on the upper right corner
 */


class C1NoteDetailView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    
    var textBlock = "TextBlock"
    
    // MARK: - Views
    lazy var scrollView         = UIScrollView()
    lazy var blockTableView     = UITableView()
    
    lazy var titleTextView      = UITextView()
    
    lazy var note = Note()
    var noteItemArray_Sorted: [NoteItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteItemArray_Sorted = note.noteItemArray.sorted { $0.noteItemOrder < $1.noteItemOrder }
        
        title = note.wrappedNoteName
        self.view.backgroundColor = .white
        
        let addBlockUIB = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        
        self.navigationItem.rightBarButtonItem = addBlockUIB
        
        blockTableView.delegate = self
        blockTableView.dataSource = self
        blockTableView.register(UINib(nibName: "TVTextBlock", bundle: nil), forCellReuseIdentifier: textBlock)
        blockTableView.bounces = false
        blockTableView.isScrollEnabled = false
        
        // MARK: - ScrollView
        // scrollView.contentSize                  = CGSize(width: Int(self.view.frame.size.width), height: 100)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize                  = self.view.frame.size
        scrollView.backgroundColor              = UIColor(named: "DarkBackground")
        // scrollView.backgroundColor = UIColor.red
        
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview()
            make.bottom.left.right.equalToSuperview()
            // make.width.equalTo(360)
        }
        
        // MARK: - UITextView
        scrollView.addSubview(titleTextView)
        titleTextView.text = note.noteName
        titleTextView.isEditable = true
        titleTextView.isScrollEnabled = false
        titleTextView.bounces = false
        titleTextView.font = UIFont.preferredFont(forTextStyle: .title1)
        
        titleTextView.delegate = self
        
        //titleTextView.layer.cornerRadius = 20
        //titleTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //
        //titleTextView.layer.shadowColor = UIColor.gray.cgColor;
        //titleTextView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        //titleTextView.layer.shadowOpacity = 0.4
        //titleTextView.layer.shadowRadius = 20
        //titleTextView.layer.masksToBounds = false
        
        titleTextView.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(scrollView.snp.top).offset(8)
            make.left.equalTo(scrollView.snp.left).offset(8)
            // make.right.equalTo(scrollView.snp.right).offset(8)
            
            make.width.equalTo(scrollView.snp.width).offset(-20)
            make.height.equalTo(50)
            
        }
        
    }
//

//

//
//        // MARK: - UITableView
//        scrollView.addSubview(blockTableView)
//        blockTableView.backgroundColor = UIColor(named: "DarkBackground")
//
//        blockTableView.snp.makeConstraints { (make) -> Void in
//            // make.width.equalTo(scrollView.snp.width).offset(-40)
//            make.top.equalTo(titleTextView.snp.bottom).offset(8)
//            // TODO: Place a TextView changable title on top of UITableView
//
//            if noteItemArray_Sorted.isEmpty {
//                print("Nothing to show")
//            }
//
//            make.height.equalTo(360)
//
//            make.left.equalTo(scrollView.snp.left).offset(10)
//            make.right.equalTo(scrollView.snp.right).offset(10)
//            make.bottom.equalTo(scrollView.snp.bottom).offset(10)
//        }
//
//        self.view.layoutIfNeeded()
//    }
//
//
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteItemArray_Sorted.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteItem = noteItemArray_Sorted[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: textBlock, for: indexPath) as! TVTextBlock

        cell.textChanged { [weak tableView] (newText: String) in
            noteItem.noteItemText = newText

            DispatchQueue.main.async {
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
        }
        return cell
    }
    
    // MARK: - Add block
    @objc func addBlock() {
        let alert = UIAlertController(title: "New block", message: "Enter some text for block", preferredStyle: .alert)
        
        // save action button
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
//            guard
//                // let textField = alert.textFields?.first,
//                // let blockToSave = textField.text
//            else {
//                return
//            }
            let blockToSave = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. MEOW"
            
            self.save(blockType: textBlock, blockText: blockToSave)
            // self.groupCollection.reloadData()
        }
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        
    }
    // MARK: - Save block
    func save(blockType: String, blockText: String) {
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
        
        blockItem.setValue(blockType, forKey: "noteItemType")
        blockItem.setValue(blockText, forKey: "noteItemText")
        
        do {
            // note.noteItemArray.insert(blockItem, at: 0)
            note.addObject(value: blockItem, forKey: "noteItems")

            print("Successfully added")
            try managedContext.save()
            
            //blockCollectionView.reloadData()
            blockTableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
        
