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
        return note.noteItemArray.count
    }
    
    // MARK: register every type of cells with each xib:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    var note = Note()
    var noteItem = NoteItem()
    
    // MARK: - note cells
    var textBlock = "TextBlock"
    
    // MARK: - Views
    lazy var scrollView         = UIScrollView()
    lazy var noteCollectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // noteCollectionView.dataSource = self
        
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
        
        
    }
    
    fileprivate func registerNoteCells() {
        noteCollectionView.register(TextBlock.self, forCellWithReuseIdentifier: textBlock)
        
        // noteCollectionView.register(<#T##nib: UINib?##UINib?#>, forCellWithReuseIdentifier: <#T##String#>)
    }
    
// note: noteName, noteLevel, noteType, noteIsMarked, noteID
// noteItem = noteItemType, noteItemName, noteItemText, noteItemOrder
    
    
}
