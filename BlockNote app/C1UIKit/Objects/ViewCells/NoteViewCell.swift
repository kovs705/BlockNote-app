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
    
    var groupType = GroupType()
    var noteType = Note()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        chevronRight.tintColor = UIColor(named: groupType.groupColor ?? "TextForegroundColor")
        
        
    }

}
