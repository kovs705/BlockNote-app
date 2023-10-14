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

    var textChanged: ((String) -> Void)?
    var beginEditing: (() -> Void)?
    
    var isDeleting = false

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
    
    // MARK: scroll to line
    func scrollToLine(_ textView: UITextView) {
        
        // getting caretRect of UITextView
        let caretRect = textView.caretRect(for: textView.selectedTextRange!.start)
        textView.caretRect(for: textView.selectedTextRange!.start)
        
        // calculate the position
        let contentOffset = CGPoint(x: 0, y: (caretRect.origin.y - textView.frame.size.height / 2) + 17)
        
        if let tableView = textView.superview?.superview?.superview as? UITableView {
            tableView.setContentOffset(contentOffset, animated: true)
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        beginEditing?()
    }

    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }

    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
        
        UIView.performWithoutAnimation {
            textView.invalidateIntrinsicContentSize()
        }
    }
    
//    func textViewDidEndEditing(_ textView: UITextView, action: @escaping () -> Void) {
//        if !isDeleting {
//            scrollToLine(textView)
//        }
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }

//        if (text == "" && textView.text.isEmpty) {
//            if let cell = textView.superview?.superview as? UITableViewCell {
//                if let tableView = cell.superview as? UITableView {
//                    c2ext.deleteblock(noteListTB: tableView, at: IndexPath(row: 1, section: 0))
//                }
//            }
//        }
        
        if text.isEmpty && range.length == 1 {
            isDeleting = true
        } else {
            isDeleting = false
        }

        return true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textChanged = nil
        beginEditing = nil
        textView.text = nil
        label.text = nil
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
