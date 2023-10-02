//
//  TVPhotoBlock.swift
//  BlockNote app
//
//  Created by Kovs on 05.07.2022.
//

import UIKit

// protocol photoSaveDelegate: AnyObject {
//    func appendPhoto(block: NoteItem?)
// }

class TVPhotoBlock: UITableViewCell {

    @IBOutlet weak var imageBlock: UIImageView!
    let cache = PersistenceController.shared.cachePhoto

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func downloadImage(for noteitem: NoteItem, completed: @escaping (UIImage?) -> Void) {
        guard let noteItemPhotoData = noteitem.noteItemPhoto else { return }

        let cacheKey = NSString(data: noteItemPhotoData, encoding: String.Encoding.utf16.rawValue)
        if let imageCacheData = cache.object(forKey: cacheKey!) {
            self.imageBlock.image = UIImage(data: imageCacheData as Data)
            print("We took this image from the cache, good work!")
            return
        }

        // if theres no cache:
        self.cache.setObject(noteItemPhotoData as NSData, forKey: cacheKey!)
        print("this image downloaded into cache!")
        DispatchQueue.main.async {
            self.imageBlock.image = UIImage(data: noteItemPhotoData)
        }
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
