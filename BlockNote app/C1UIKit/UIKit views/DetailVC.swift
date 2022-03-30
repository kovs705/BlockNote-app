//
//  DetailVCViewController.swift
//  BlockNote app
//
//  Created by Kovs on 25.03.2022.
//

import UIKit
import CoreData
import SwiftUI

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
// segue
    let segueToNoteView = "showNoteView"
// CoreData properties
    let noteName = "noteName"
    let noteID = "noteID"
    let noteLevel = "noteLevel"
    let noteIsMarked = "noteIsMarked"
    

    // MARk: - did load
    override func viewDidLoad() {
        super.viewDidLoad()

        title = groupType.groupName ?? "Unknown"
        
        setupDetailVC()
    }

}

extension DetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groupType.typesOfNoteArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let noteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteViewCell", for: indexPath) as! NoteViewCell
        
    // configuring cell
        noteCell.setNoteName(name: groupType.typesOfNoteArray[indexPath.row].value(forKey: "noteName") as! String)
        noteCell.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return noteCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width-4)/1, height: 50)
    }
    
    func setupDetailVC() {
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        
        noteListCollection.backgroundColor = UIColor(named: "DarkBackground")
        noteListCollection.register(UINib(nibName: "NoteViewCell", bundle: nil), forCellWithReuseIdentifier: "NoteViewCell")
        
        numberOfNotesLabel.text = "\(groupType.typesOfNoteArray.count)"
        
        topBar.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
        first_column.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
        second_column.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
        third_column.backgroundColor = UIColor(named: "\(groupType.groupColor ?? "BlueBerry")")
    }
    
}
