//
//  TVTextBlock.swift
//  BlockNote app
//
//  Created by Kovs on 11.05.2022.
//

import UIKit

class TVTextBlock: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var textChanged: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // textView.delegate = self
    }
    
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged?(textView.text)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
