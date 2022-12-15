//
//  TVTitleBlock.swift
//  BlockNote app
//
//  Created by Kovs on 05.07.2022.
//

import UIKit
import CoreData

protocol titleSaveDelegate: AnyObject {
    func update(titleText: String, block: NoteItem?)
    func getTitle(text: String?)
}

class TVTitleBlock: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var titleTextView: UITextView!
    
    weak var delegate: titleSaveDelegate?
    var textChanged: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextView.delegate = self
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
