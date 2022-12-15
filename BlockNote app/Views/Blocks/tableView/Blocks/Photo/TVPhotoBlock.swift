//
//  TVPhotoBlock.swift
//  BlockNote app
//
//  Created by Kovs on 05.07.2022.
//

import UIKit

//protocol photoSaveDelegate: AnyObject {
//    func appendPhoto(block: NoteItem?)
//}

class TVPhotoBlock: UITableViewCell {

    @IBOutlet weak var imageBlock: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageBlock.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
