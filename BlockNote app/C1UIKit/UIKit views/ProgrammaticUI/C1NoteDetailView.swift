//
//  C1NoteDetailView.swift
//  BlockNote app
//
//  Created by Kovs on 13.04.2022.
//

import CoreData
import UIKit


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
