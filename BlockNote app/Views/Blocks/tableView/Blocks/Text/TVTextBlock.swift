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
    
    
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        // textChanged?(textView.text)
//        delegate?.getText(text: textView.text)
//    }

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
