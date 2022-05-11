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


class C1NoteDetailView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var textBlock = "TextBlock"
    
    // MARK: - Views
    lazy var scrollView         = UIScrollView()
    lazy var blockTableView     = UITableView()
    
    lazy var note = Note()
    var noteItemArray_Sorted: [NoteItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteItemArray_Sorted = note.noteItemArray.sorted { $0.noteItemOrder < $1.noteItemOrder }
        
        title = note.wrappedNoteName
        self.view.backgroundColor = .white
        blockTableView.delegate = self
        blockTableView.dataSource = self
        blockTableView.register(UITableViewCell.self, forCellReuseIdentifier: textBlock)
        blockTableView.bounces = false
        blockTableView.isScrollEnabled = false
        
        // let rightAddButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.addBlockNote))
        
        // self.navigationItem.rightBarButtonItem = rightAddButton
        
        // MARK: - ScrollView
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
        
        scrollView.addSubview(blockTableView)
        blockTableView.backgroundColor = UIColor(named: "DarkBackground")
        
        blockTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(scrollView.snp.width).offset(-40)
            make.top.equalTo(scrollView.snp.top).offset(25)
            // TODO: Place a TextView changable title on top of UITableView
            
            if !noteItemArray_Sorted.isEmpty {
                make.height
            }
        }
        
    }
    
    
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
    
}
        
