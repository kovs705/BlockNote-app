//
//  TVTextBlock.swift
//  BlockNote app
//
//  Created by Kovs on 11.05.2022.
//

import UIKit
import SnapKit
import CoreData

class TVTextBlock: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var focusLineHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!

//    let c2ext = C2NoteDetailExt()
    let noteDetail = C3NoteDetailVC()

    lazy var verticalLineView = UIView(frame: CGRect(x: 10, y: 0, width: 4, height: focusLineHeightConstraint.constant))

    var textChanged: ((String) -> Void)?
    var beginEditing: (() -> Void)?
    
    var isDeleting = false

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

    // MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        configureFocusLineView(color: .purple)
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
            print("Scrolling completed")
        }
        
    }
    
    // MARK: focus line view
    func configureFocusLineView(color: UIColor) {
        verticalLineView.backgroundColor = color
        self.contentView.addSubviews(verticalLineView)
        
        verticalLineView.snp.makeConstraints { make in
            make.height.equalTo(textView.snp.height)
        }
//        let newHeight = textView.text.heightWithConstrainedWidth(width: textView.frame.width, font: UIFont.systemFont(ofSize: 17))
        
        UIView.animate(withDuration: 0.2, animations: {
            self.verticalLineView.layoutIfNeeded()
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        beginEditing?()
    }

    func textViewDidEndEditing(_ textView: UITextView, action: @escaping () -> Void) {
//        if !isDeleting {
//            scrollToLine(textView)
//        }
    }

    func textChanged(action: @escaping (String) -> Void) {
        textChanged = action
    }

    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
        
//        if !isDeleting {
//            scrollToLine(textView)
//        }
        
        UIView.performWithoutAnimation {
            textView.invalidateIntrinsicContentSize()
        }
    }
    
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
            // Deleting text
            isDeleting = true
        } else {
            isDeleting = false
        }

        return true
    }

    // MARK: reuse
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
