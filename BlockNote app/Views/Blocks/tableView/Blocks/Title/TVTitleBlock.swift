//
//  TVTitleBlock.swift
//  BlockNote app
//
//  Created by Kovs on 05.07.2022.
//

import UIKit
import CoreData

class TVTitleBlock: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    
    weak var delegate: textSaveDelegate?
    var textChanged: ((String) -> Void)?
    
    let cache = PersistenceController.shared.cacheString
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    func loadText(for noteItem: NoteItem, completed: @escaping (String?) -> Void) {
        let noteItemStringData = noteItem.noteItemText
        let cacheKey = NSString(utf8String: noteItemStringData)
        
        if let stringCacheData = cache.object(forKey: cacheKey!) {
            // print("We took this text from cache, good work!")
            let stringCache = stringCacheData as String
            
            self.textView.text = stringCache
            self.label.text = stringCache
            
            return
        }
        
        // if theres no cache:
        self.cache.setObject(noteItemStringData as NSString, forKey: cacheKey!)
        // print("this text downloaded into cache!")
        
        DispatchQueue.main.async {
            self.textView.text = noteItemStringData
            self.label.text = noteItemStringData
        }
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textChanged = nil
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
