//
//  C1NoteView.swift
//  BlockNote app
//
//  Created by Kovs on 17.03.2022.
//

import CoreData
import UIKit

class C1NoteView: UIViewController {
    
    lazy var note = Note()
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = note.wrappedNoteName
        scrollView.alwaysBounceVertical = true
        
        
    }
    
    
    
}


