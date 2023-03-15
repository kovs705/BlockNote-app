//
//  TVTextBlock.swift
//  BlockNote app
//
//  Created by Kovs on 11.05.2022.
//

import UIKit
import CoreData

protocol textSaveDelegate: AnyObject {
    func update(blockText: String, block: NoteItem?, noteListTB: UITableView)
    func getText(text: String?, noteListTB: UITableView)
}

class TVTextBlock: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    
    var textChanged: ((String) -> Void)?
    weak var delegate: textSaveDelegate?
    
    let cache = PersistenceController.shared.cacheString
    
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
    
//    func deleteCacheBeforeUsing(for noteItem: NoteItem, completed: @escaping (String?) -> Void) {
//        let noteItemStringData = noteItem.noteItemText
//        if let cacheKey = NSString(utf8String: noteItemStringData) {
//            cache.removeObject(forKey: cacheKey)
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        textChanged = action
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
