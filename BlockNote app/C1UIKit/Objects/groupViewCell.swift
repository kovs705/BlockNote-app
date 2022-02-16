//
//  groupViewCell.swift
//  BlockNote app
//ц
//  Created by Kovs on 28.01.2022.
//

import UIKit

class groupViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var numberOfNotes: UILabel!
    
    func setBackground(color: String) {
        // containerView.backgroundColor = returnUIColorFromString(string: color)
        containerView.backgroundColor = UIColor.appColor(AssetsColor(rawValue: color)!)
    }
    func setGroupName(label: String) {
        groupName.text = label
    }
    func setNumber(numLabel: String, number: Int) {
        if number == 0 {
        numberOfNotes.text = "0 notes"
        }
        else if number == 1 {
            numberOfNotes.text = "1 note"
        }
        else {
            numberOfNotes.text = "\(number) notes"
        }
    }
    
}
