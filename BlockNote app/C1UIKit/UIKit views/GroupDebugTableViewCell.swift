//
//  GroupDebugTableViewCell.swift
//  BlockNote app
//
//  Created by Kovs on 16.01.2022.
//

import UIKit

class GroupDebugTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var numberOfNotes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
