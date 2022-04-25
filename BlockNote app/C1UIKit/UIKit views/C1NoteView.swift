//
//  C1NoteView.swift
//  BlockNote app
//
//  Created by Kovs on 17.03.2022.
//

import CoreData
import UIKit

class C1NoteView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    lazy var note = Note()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topNoteName: UITextView!
    @IBOutlet weak var blockCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation and ScrollView
        title = note.wrappedNoteName
        scrollView.alwaysBounceVertical = true
        
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
        <#code#>
    }
    
    
    
}


