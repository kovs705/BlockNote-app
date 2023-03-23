//
//  ImageCollectionViewCell.swift
//  BlockNote app
//
//  Created by Kovs on 23.03.2023.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let imageCell = "imageCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
