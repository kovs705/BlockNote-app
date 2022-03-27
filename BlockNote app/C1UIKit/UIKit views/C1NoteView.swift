//
//  C1NoteView.swift
//  BlockNote app
//
//  Created by Kovs on 17.03.2022.
//

import CoreData
import UIKit

class C1NoteView: UIViewController {
    
    var noteType = Note()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = noteType.wrappedNoteName
        
    }
    
}


