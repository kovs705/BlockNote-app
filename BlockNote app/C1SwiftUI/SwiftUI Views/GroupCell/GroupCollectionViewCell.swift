//
//  GroupCollectionViewCell.swift
//  BlockNote app
//
//  Created by Kovs on 20.12.2021.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var numberOfNotesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
