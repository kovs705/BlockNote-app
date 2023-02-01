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
    func getText(text: String?)
}

class TVTextBlock: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var textChanged: ((String) -> Void)?
    
    weak var delegate: textSaveDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }
    
    class UITextViewPadding : UITextView {
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
      }
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
