//
//  C2DetailVC.swift
//  BlockNote app
//
//  Created by Kovs on 08.07.2023.
//

import UIKit

protocol detail_vc_Delegate {
    func deleteAndUpdate()
    func closeAndDelete()
    
    //TODO: first sort important on top, then sort by order
}

class C2DetailVC: UIViewController {
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
    
    var presenter: C2DetailPresenterProtocol!
    var delegate: detail_vc_Delegate?
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.groupType.groupName ?? "Unknown"
        
        presenter.sortArray()
        // noteArraySorted = groupType.typesOfNoteArray.sorted(by: { $0.noteID < $1.noteID })
        
        setupDetailVC(scrollView: scrollView, noteListCollection: noteListCollection, numberOfNotesLabel: numberOfNotesLabel, topBar: topBar, first_column: first_column, second_column: second_column, third_column: third_column)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        noteListCollection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteDetail" {
            if let destination = segue.destination as? C2DetailVC,
               let noteIndex = noteListCollection.indexPathsForSelectedItems?.first {
                destination.presenter.noteObject = presenter.noteArraySorted[noteIndex.row]
            }
        } else if segue.identifier == "agenda" {
            if let destination = segue.destination as? AgendaVC,
               let noteIndex = noteListCollection.indexPathsForSelectedItems?.first {
                destination.note = presenter.noteArraySorted[noteIndex.row]
            }
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func addNoteButton(sender: UIButton!) {
        presenter.addNote()
    }
    
    @IBAction func deleteGroup(_ sender: UIButton) {
        presenter.deleteGroup(groupName: presenter.groupType.wrappedGroupName)
    }
    
    
    // MARK: - UI configuration
    
    private func setupDetailVC(scrollView: UIScrollView, noteListCollection: UICollectionView, numberOfNotesLabel: UILabel, topBar: UIView, first_column: UIStackView, second_column: UIStackView, third_column: UIStackView) {
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        
        // noteListCollection.backgroundColor = UIColor(named: "BackWhite")
        noteListCollection.register(UINib(nibName: "NoteViewCell", bundle: nil), forCellWithReuseIdentifier: "NoteViewCell")
        noteListCollection.allowsSelection = true
        noteListCollection.allowsMultipleSelection = true
        
        numberOfNotesLabel.text = "\(presenter.groupType.typesOfNoteArray.count)"
        
        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.masksToBounds = false
        
        topBar.layer.cornerRadius = 20
        topBar.shadowOffset = CGSize(width: 5, height: 0)
        topBar.layer.shadowRadius = 10
        topBar.shadowOpacity = 0.3
        topBar.layer.shadowPath = CGPath(rect: topBar.bounds, transform: nil)
        
        topBar.backgroundColor = UIColor(named: "\(presenter.groupType.groupColor ?? "BlueBerry")")
        
        first_column.backgroundColor = UIColor(named: "\(presenter.groupType.groupColor ?? "BlueBerry")")
        second_column.backgroundColor = UIColor(named: "\(presenter.groupType.groupColor ?? "BlueBerry")")
        third_column.backgroundColor = UIColor(named: "\(presenter.groupType.groupColor ?? "BlueBerry")")
    }
    
    
}

// MARK: - UICollectinView extensions
extension C2DetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // groupType.typesOfNoteArray.count
        presenter.noteArraySorted.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let noteCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.noteViewCell, for: indexPath) as! NoteViewCell
        
        // configuring cell
        // noteCell.setNoteName(name: groupType.typesOfNoteArray[indexPath.row].value(forKey: "noteName") as! String)
        noteCell.setNoteName(name: presenter.noteArraySorted[indexPath.row].value(forKey: Keys.nName) as! String)
        noteCell.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return noteCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width-4)/1, height: 50)
    }
    
    // MARK: - Segue to the blocks
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let note = presenter.noteArraySorted[indexPath.row]
        
        defer {
            collectionView.isUserInteractionEnabled = true
        }
//        performSegue(withIdentifier: Cells.noteDetail, sender: indexPath)
        pushToNoteDetail(using: note)
        collectionView.isUserInteractionEnabled = false
    }
    
    func pushToNoteDetail(using note: Note) {
        let coordinator = Builder()
        let vc = coordinator.getC3NoteDetailVC(note: note)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen // fullscreen?
        present(vc, animated: true)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    //        collectionView.reloadItems(at: [indexPath])
    //        collectionView.deselectItem(at: indexPath, animated: true)
    //    }
}


// MARK: - Protocol
extension C2DetailVC: C2DetailViewProtocol {
    
    func popVC() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func performBatchUpdates() {
        noteListCollection.performBatchUpdates({
            noteListCollection.insertItems(at: [IndexPath(item: presenter.noteArraySorted.count - 1, section: 0)])
        }, completion: nil)
    }
    
    func presentAlert(_ alert: UIAlertController, animated: Bool) {
        present(alert, animated: animated)
    }
    
}
