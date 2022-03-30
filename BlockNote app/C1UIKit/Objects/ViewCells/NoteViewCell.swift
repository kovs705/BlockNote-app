//
//  NoteViewCell.swift
//  BlockNote app
//
//  Created by Kovs on 28.03.2022.
//

import UIKit
import CoreData

class NoteViewCell: UICollectionViewCell {
    
    @IBOutlet weak var noteName: UILabel!
    @IBOutlet weak var chevronRight: UIImageView!
    
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var greenView: UIView!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    // var groupType = GroupType()
    var noteType = Note()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // chevronRight.tintColor = UIColor(named: groupType.groupColor ?? "TextForegroundColor")
        noteLabel.text = noteType.noteName
        
    }

}
