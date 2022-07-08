//
//  C1NoteView.swift
//  BlockNote app
//
//  Created by Kovs on 17.03.2022.
//

import CoreData
import UIKit

// class C1NoteView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
class C1NoteView: UICollectionViewController {
    // let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: C1NoteDetailTBC.self, action: #selector(backSaveChanging))
    
    @IBOutlet var noteDetailCV: UICollectionView!
    
    
    lazy var note = Note()
    var noteItemArray_sorted: [NoteItem] = []
    
    @Published var getNote = "value"
    
    // RxSwift: future thing, I guess
    // var db = DisposeBag()
    
    // block types:
    let textBlock = "TextBlock"
    var textForTextlock: String = ""
    var updateBool: Bool = false
    
    var indexOfBlock = 0
    // var editingBool = false
    
    var noteItemArray_Sorted: [NoteItem] = []
    

    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let addBlockUIB = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        
        // self.navigationItem.rightBarButtonItem = addBlockUIB
    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        noteDetailCV.reloadData()
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
    
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


