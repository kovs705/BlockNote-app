//
//  C1NoteView.swift
//  BlockNote app
//
//  Created by Kovs on 17.03.2022.
//

import CoreData
import UIKit

class C1NoteView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var note = Note()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topNoteName: UITextView!
    @IBOutlet weak var blockCollectionView: UICollectionView!
    
    var noteItemArray_Sorted: [NoteItem] = []
    
    // blockTypes:
    let textBlock = "TextBlock"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation and ScrollView
        title = note.wrappedNoteName
        scrollView.alwaysBounceVertical = true
        
        // Sorting and other stuff
        noteItemArray_Sorted = note.noteItemArray.sorted { $0.noteItemOrder < $1.noteItemOrder }
        
        // UICollectionView
        blockCollectionView.allowsSelection = true
        blockCollectionView.dataSource      = self
        blockCollectionView.delegate        = self
        
        
        
        
    }
    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        note.noteItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let noteItem = noteItemArray_Sorted[indexPath.row]
        
        if noteItem.noteItemType == textBlock {
            let textBlockCell = collectionView.dequeueReusableCell(withReuseIdentifier: <#T##String#>, for: <#T##IndexPath#>)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        <#code#>
    }
    
    
    
    
}

/*
 To continue I need to know what type of cells user will have
    taskBlock - list of tasks
    vocabularyBlock - show the translation by clicking on word
    mapBlock - attach some coordinates on map (share - open in Google Maps)
 TextBlock  <------ in progress
    ImageBlock
 ======================
 make a grey colored loading on the upper right corner
 */


