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
    weak var textSaveDelegate: textSaveDelegate?
    
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        
        // add a new block here
        
        return true
    }
    
    func scrollToLine(_ textView: UITextView) {
        
        // getting caretRect of UITextView
        let caretRect = textView.caretRect(for: textView.selectedTextRange!.start)
        textView.caretRect(for: textView.selectedTextRange!.start)
        
        // calculate the position
        let contentOffset = CGPoint(x: 0, y: (caretRect.origin.y - textView.frame.size.height / 2) + 15)
        
        if let tableView = textView.superview?.superview?.superview as? UITableView {
            tableView.setContentOffset(contentOffset, animated: true)
            print("Scrolling completed")
        }
        
    }
    
    func scrollToCell(_ textView: UITextView) {
        if let cell = textView.superview?.superview as? UITableViewCell {
            if let tableView = cell.superview as? UITableView {
                if let indexPath = tableView.indexPath(for: cell) {
                    tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    print("Scroll to the indexPath: \(indexPath.row) completed")
                }
            }
        }
    }
    
    func configureTag(forIndexPath indexPath: IndexPath) {
        textView.tag = indexPath.row
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        scrollToLine(textView)
//    }
    
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
