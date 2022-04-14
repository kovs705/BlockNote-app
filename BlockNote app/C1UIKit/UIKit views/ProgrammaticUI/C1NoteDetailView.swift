//
//  C1NoteDetailView.swift
//  BlockNote app
//
//  Created by Kovs on 13.04.2022.
//

import CoreData
import UIKit

/*
 To continue I need to know whhat type of cells user will have
 taskBlock - list of tasks
 vocabularyBlock - show the translation by clicking on word
 mapBlock - attach some coordinates on map (share - open in Google Maps)
 TextBlock
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
    
// note: noteName, noteLevel, noteType, noteIsMarked, noteID
// noteItem = noteItemType, noteItemName, noteItemText, noteItemOrder
    
    
}
