//
//  TVTextBlock.swift
//  BlockNote app
//
//  Created by Kovs on 11.05.2022.
//

import UIKit
import CoreData

class TVTextBlock: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    
//    let c2ext = C2NoteDetailExt()
    let noteDetail = C3NoteDetailVC()
    
    lazy var verticalLineView = UIView(frame: CGRectMake(10, 0, 4, textView.text.heightWithConstrainedWidth(width: textView.frame.width, font: UIFont.systemFont(ofSize: 17)) + 4))
    
    var textChanged: ((String) -> Void)?
    
    let cache = PersistenceController.shared.cacheString
    
    func loadText(for noteItem: NoteItem, completed: @escaping (String?) -> Void) {
        let noteItemStringData = noteItem.noteItemText
        let cacheKey = NSString(utf8String: noteItemStringData)
        
        if let stringCacheData = cache.object(forKey: cacheKey!) {
            // print("We took this text from cache, good work!")
            let stringCache = stringCacheData as String
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.textView.text = stringCache
                self.label.text = stringCache
                self.configureFocusLineView(color: .purple)
            }
            
            return
        }
        
        // if theres no cache:
        cache.setObject(noteItemStringData as NSString, forKey: cacheKey!)
        // print("this text downloaded into cache!")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.textView.text = noteItemStringData
            self.label.text = noteItemStringData
            self.configureFocusLineView(color: .purple)
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
        
//        if (text == "" && textView.text.isEmpty) {
//            if let cell = textView.superview?.superview as? UITableViewCell {
//                if let tableView = cell.superview as? UITableView {
//                    c2ext.deleteblock(noteListTB: tableView, at: IndexPath(row: 1, section: 0))
//                }
//            }
//        }
        
        return true
    }
    
    func scrollToLine(_ textView: UITextView) {

        // getting caretRect of UITextView
        let caretRect = textView.caretRect(for: textView.selectedTextRange!.start)
        textView.caretRect(for: textView.selectedTextRange!.start)

        // calculate the position
        let contentOffset = CGPoint(x: 0, y: (caretRect.origin.y - textView.frame.size.height / 2) + 17)

            if let tableView = textView.superview?.superview?.superview as? UITableView {
                tableView.setContentOffset(contentOffset, animated: true)
                print("Scrolling completed")
            }


    }
    
    func configureFocusLineView(color: UIColor) {
        verticalLineView.backgroundColor = color
        self.contentView.addSubview(verticalLineView)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let cell = textView.superview?.superview as? UITableViewCell {
            if let tableView = cell.superview as? UITableView {
                if let indexPath = tableView.indexPath(for: cell) {
                    noteDetail.indexOfBlock = indexPath.row
                    print("IT BECAME \(noteDetail.indexOfBlock)")
                }
            }
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView, action: @escaping () -> Void) {
        print("Ok, started")
    }
    
    func textViewDidEndEditing(_ textView: UITextView, action: @escaping () -> Void) {
        print("Ok, ended")
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
        textView.text = nil
        label.text = nil
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
