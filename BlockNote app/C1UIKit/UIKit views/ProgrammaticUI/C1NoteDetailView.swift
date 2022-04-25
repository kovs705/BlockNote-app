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


class C1NoteDetailView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return note.noteItemArray.count
        return noteItemArraySorted.count
    }
    
    // MARK: register every type of cells with each xib:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let note = noteItemArraySorted[indexPath.row]
        
        if note.noteItemType == textBlock {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textBlock, for: indexPath) as! TextBlock
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: textBlock, for: indexPath) as! TextBlock
            return cell
        }
        
    }
    
    var note = Note()
    // var noteItem = NoteItem()
    
    var noteItemArraySorted: [NoteItem] = [NoteItem]()
    
    var blockType = ""
    
    // MARK: - note cells
    var textBlock = "TextBlock"
    
    // MARK: - Views
    lazy var scrollView         = UIScrollView()
    lazy var noteCollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteItemArraySorted = note.noteItemArray.sorted(by: { $0.noteItemOrder < $1.noteItemOrder })
        
        title = note.wrappedNoteName
        self.view.backgroundColor = .white
        
        let rightAddButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.addBlockNote))
        
        self.navigationItem.rightBarButtonItem = rightAddButton
        
        // MARK: - ScrollView
        scrollView.bounces                      = true
        // scrollView.isPagingEnabled = true
        scrollView.contentSize                  = CGSize(width: Int(self.view.frame.size.width), height: 100)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize                  = self.view.frame.size
        scrollView.backgroundColor              = UIColor(named: "DarkBackground")
        
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.bottom.left.right.equalTo(view)
        }
        
        // MARK: - UICollectionView
        registerNoteCells()
        
        noteCollectionView.dataSource = self
        noteCollectionView.bounces = false
        noteCollectionView.isScrollEnabled = false
        
        scrollView.addSubview(noteCollectionView)
        noteCollectionView.backgroundColor = UIColor(named: "DarkBackground")
        
        noteCollectionView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(scrollView.snp.width).offset(-40)
            make.top.equalTo(scrollView.snp.top).offset(25)
            // height:
            // make.height.greaterThanOrEqualToSuperview()
            make.height.greaterThanOrEqualTo(scrollView.snp.height)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalTo(scrollView.snp.bottom).offset(20)
        }
        
        self.view.layoutIfNeeded()
        
    }
    
    @objc func addBlockNote() {
        let chooseBlockMenu = UIAlertController(title: nil, message: "Choose your block", preferredStyle: .actionSheet)
        
        let textBlock = UIAlertAction(title: "Text Block", style: .default) { action in
            //
            print("add Text Block")
        }
        
        let close = UIAlertAction(title: "Cancel", style: .cancel)
        
        chooseBlockMenu.addAction(textBlock)
        chooseBlockMenu.addAction(close)
        
        self.present(chooseBlockMenu, animated: true)
    }
    
    func addBlock(blockType: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let viewContext = appDelegate.persistentContainerOffline.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NoteItem", in: viewContext)!
        let noteItem = NSManagedObject(entity: entity, insertInto: viewContext)
        
        if blockType == textBlock {
            noteItem.setValue(blockType, forKey: "noteItemType")
        } else {
            return
        }
        // MARK: - make other types of blocks
        
        if note.noteItemArray.isEmpty {
            noteItem.setValue(1, forKey: "noteItemOrder")
        } else {
            noteItem.setValue((note.noteItemArray.last?.noteItemOrder ?? 0) + 1, forKey: "noteItemOrder")
        }
        
        noteItem.setValue("Lorem ipsum dolor sit amet or how is it written correctly?))", forKey: "noteItemText")
        
        do {
            self.note.addObject(value: noteItem, forKey: "noteItems")
            
            if self.note.hasChanges {
                try viewContext.save()
            } else {
                fatalError("Just testing if something will go wrong, delete it after some time")
            }
            
            self.noteCollectionView.layoutIfNeeded()
            self.noteCollectionView.updateConstraints()
            self.noteCollectionView.reloadData()
        } catch let error as NSError {
            print("Could not save and add note. \(error), \(error.userInfo)")
        }
        
    }
    
    fileprivate func registerNoteCells() {
        noteCollectionView.register(TextBlock.self, forCellWithReuseIdentifier: textBlock)
    }
    
// note: noteName, noteLevel, noteType, noteIsMarked, noteID
// noteItem = noteItemType, noteItemName, noteItemText, noteItemOrder
    
    
}
