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

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!

    lazy var verticalLineView = UIView(frame: CGRect(x: 10, y: 0, width: 4, height: 245 ))

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
                textView.text = stringCache
                label.text = stringCache
                configureFocusLineView(color: .purple)
            }

            return
        }

        // if theres no cache:
        cache.setObject(noteItemStringData as NSString, forKey: cacheKey!)
        // print("this text downloaded into cache!")

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            textView.text = noteItemStringData
            label.text = noteItemStringData
            configureFocusLineView(color: .purple)
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
        let contentOffset = CGPoint(x: 0, y: (caretRect.origin.y - textView.frame.size.height / 2) + 17)
        
        if let tableView = textView.superview?.superview?.superview as? UITableView {
            tableView.setContentOffset(contentOffset, animated: true)
        }
        
    }
    
    // MARK: focus line view
    func configureFocusLineView(color: UIColor) {
        verticalLineView.backgroundColor = color
        self.contentView.addSubview(verticalLineView)
        
        verticalLineView.snp.makeConstraints { make in
            make.height.equalTo(textView.snp.height)
        }
        
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
        
        UIView.performWithoutAnimation {
            textView.invalidateIntrinsicContentSize()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        isDeleting = text.isEmpty && range.length == 1

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

}
