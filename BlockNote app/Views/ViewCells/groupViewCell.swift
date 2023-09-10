//
//  groupViewCell.swift
//  BlockNote app
//ц
//  Created by Kovs on 28.01.2022.
//

import UIKit

class groupViewCell: GroupUICollectionViewCellAnimated {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var numberOfNotes: UILabel!
    @IBOutlet weak var groupEmoji: UILabel!
    
    func setGroupCell(group: GroupType) {
        setBackground(group)
        setGroupName(group)
        setNumber(group)
        setGroupEmoji(group)
    }
    
    func setBackground(_ group: GroupType) {
        // containerView.backgroundColor = returnUIColorFromString(string: color)
        containerView.backgroundColor = UIColor.appColor(AssetsColor(rawValue: group.groupColor!)!)
    }
    func setGroupName(_ group: GroupType) {
        groupName.text = group.groupName
    }
    func setNumber(_ group: GroupType) {
        guard let number = group.noteTypes?.count else { return }
        if number == 0 {
            numberOfNotes.text = "0 notes"
        } else if number == 1 {
            numberOfNotes.text = "1 note"
        } else {
            numberOfNotes.text = "\(number) notes"
        }
    }
    
    func setGroupEmoji(_ group: GroupType) {
        groupEmoji.text = group.wrappedEmoji
    }
    
}

