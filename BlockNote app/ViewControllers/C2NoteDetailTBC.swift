//
//  C2NoteDetailTBC.swift
//  BlockNote app
//
//  Created by Kovs on 06.02.2023.
//

import UIKit

class C2NoteDetailTBC: C2NoteDetailExt, textSaveDelegate, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate{

    @IBOutlet weak var noteListTB: UITableView!
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sortAndUpdate()
        configureTableView()
        
        title = note.wrappedNoteName
        
        let addBlockButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        self.navigationItem.rightBarButtonItem = addBlockButton
        
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureDock()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteListTB.contentInset = .zero
        } else {
            noteListTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: notification.keyboardHeight - view.safeAreaInsets.bottom, right: 0)
        }
        
        noteListTB.scrollIndicatorInsets = noteListTB.contentInset
    }
    
    

    
    func configureTableView() {
        noteListTB.delegate = self
        noteListTB.dataSource = self
        noteListTB.dragDelegate = self
        noteListTB.dragInteractionEnabled = true
        noteListTB.sectionHeaderHeight = 100
    }
    
    // MARK: - Add photo block
    @objc func showPhotoPicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true)
    }
    
    // MARK: - UIAlertController
    @objc func addBlock() {
        let alert = UIAlertController(title: "New block", message: "Choose your block", preferredStyle: .actionSheet)
        
        let saveTitleBlock = UIAlertAction(title: "Header", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            self.save(blockType: Block.titleBlock, theCase: .title, noteListTB: self.noteListTB, pickedImage: nil)
        }
        
        let saveTextBlock = UIAlertAction(title: "Text", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            self.save(blockType: Block.textBlock, theCase: .text, noteListTB: self.noteListTB, pickedImage: nil)
        }
        
        let saveSpaceBlock = UIAlertAction(title: "Spacer", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.save(blockType: Block.spaceBlock, theCase: .space, noteListTB: self.noteListTB, pickedImage: nil)
        }
        
        // photoBlock save
        let savePhotoBlock = UIAlertAction(title: "Photo", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.showPhotoPicker()
        }
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // alert.addTextField()
        alert.addAction(saveTitleBlock)
        alert.addAction(saveTextBlock)
        alert.addAction(savePhotoBlock)
        alert.addAction(saveSpaceBlock)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        
    }
    
    // MARK: - Get text
    func getText(text: String?, noteListTB: UITableView) {
        
        textForTextlock = text ?? "Nothing in the text, or it's just the bug."
        update(blockText: textForTextlock, block: self.noteItemArray_sorted[indexOfBlock], noteListTB: noteListTB)
        // print("you changed the block with the index of \(indexOfBlock)")
    }
    
    // MARK: - update block
    func update(blockText: String, block: NoteItem?, noteListTB: UITableView) {
        
/// update the date of the last changing
        block?.setValue(Date(), forKey: Keys.niLastChanged)
/// update the text of the block
        block?.setValue(blockText, forKey: Keys.niText)
        
        delegateSave()
    }
    
    
    // MARK: - keyboard detect (work in progress)
//    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
//        guard let key = presses.first?.key else { return }
//
//        switch key.keyCode {
//        case .keyboardReturnOrEnter:
//            noteListTB.endEditing(true)
//
//            saveAndStartTyping()
//        default:
//            super.pressesEnded(presses, with: event)
//        }
//    }
    
   // MARK: - Func to create a new textBlock by clicking on return button + make the last block (this text block) as a first responder and start typing there:
    func saveAndStartTyping() {
        
        print("You tapped return button on keyboard")           // check with print func
        save(blockType: Block.textBlock, theCase: .text, noteListTB: noteListTB, pickedImage: nil)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.noteListTB.beginUpdates()
            self.noteListTB.endUpdates()
        }

//        guard let lastBlock = noteItemArray_sorted.last?.noteItemOrder else {
//            print("Couldn't get the last order after clicking return button")
//            return
//        }
//
//        // MARK: - TODO - Add text check (for deleting)
//
//         let cell = noteListTB.dequeueReusableCell(withIdentifier: textBlock, for: IndexPath(index: lastBlock - 1)) as! TVTextBlock  // order is +1 than indexPath
//         cell.textView.becomeFirstResponder()
        
//        if let lastBlock = noteItemArray_sorted.last?.noteItemOrder {
//            let cell = noteListTB.dequeueReusableCell(withIdentifier: textBlock, for: IndexPath(index: lastBlock - 1)) as! TVTextBlock
//            print("\(lastBlock - 1)")
//            cell.textView.becomeFirstResponder()
//        } else {
//            return
//        }
        
        
    }
    
//    // MARK: - Get the order
//    func startEndEditing(switchType: Bool) {
//        if switchType == true {
//            editingBool = switchType
//            // self.indexOfBlock = IndexPath(row: indexPath.row, section: 0)
//            print("You started changing the text in \(self.noteItemArray_sorted[indexOfBlock.row].noteItemOrder) block")
//        } else {
//            editingBool = switchType
//            indexOfBlock = IndexPath(row: 0, section: 0)
//        }
//    }
    
    // TODO: append Photo гав
//    func appendPhoto(block: NoteItem?) {
//
//    }
    

}

// MARK: - Photo block and ImagePicker extension
    // TODO: Гав, make a cell with up to 3-4 photos with a fixed size
extension C2NoteDetailTBC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("closed")
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Image Data
        guard let pickedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        // let pickedImage = info[.originalImage] as? UIImage
        
        //        guard letjpegImage = pickedImage.jpegData(compressionQuality: 1.0) else {
        //            return
        //        }
        // image = jpegImage
        
        // pickedImage.toData as NSData?
        
        //        do {
        //            image = try NSKeyedArchiver.archivedData(withRootObject: image! as Data, requiringSecureCoding: true)
        //        } catch {
        //            print("error")
        //        }
        
        save(blockType: Block.photoBlock, theCase: .photo, noteListTB: noteListTB, pickedImage: pickedImage)
        
        picker.dismiss(animated: true)

        dismiss(animated: true, completion: nil)
        
    }




// MARK: - UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let noteItem = noteItemArray_sorted[indexPath.row]
        
        if noteItem.value(forKey: Keys.niType) as! String == Block.textBlock {
            return noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width-60, font: UIFont.systemFont(ofSize: 17))
            
        } else if noteItem.value(forKey: Keys.niType) as! String == Block.titleBlock {
            return noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width, font: UIFont.systemFont(ofSize: 22))
            
        } else if noteItem.value(forKey: Keys.niType) as! String == Block.photoBlock {
            let image = UIImage(data: noteItem.noteItemPhoto!)
            let imageCrop = image!.getCropRatio()
            return tableView.frame.width / imageCrop
        } else {
            return 30
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteItemArray_sorted.count
    }
    
    // MARK: - Drag&Drop UITableView
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = noteItemArray_sorted[indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // update the model:
        
        
        let mover = noteItemArray_sorted.remove(at: sourceIndexPath.row)
        noteItemArray_sorted.insert(mover, at: destinationIndexPath.row)
        
        print(sourceIndexPath.row)
        print(destinationIndexPath.row)
        
        for block in self.noteItemArray_sorted {
            let blockIndex = block.noteItemOrder - 1
            // from top to bottom:
            if sourceIndexPath.row > destinationIndexPath.row {
                if !(blockIndex < destinationIndexPath.row) {
                    if blockIndex <= sourceIndexPath.row {
                        block.setValue(block.noteItemOrder + 1, forKey: Keys.niOrder)
                    }
                }
            } else {
                // from bottom to top:
                if blockIndex > sourceIndexPath.row {
                    if blockIndex <= destinationIndexPath.row {
                        block.setValue(block.noteItemOrder - 1, forKey: Keys.niOrder)
                    }
                }
            }
            
        }
        mover.setValue(destinationIndexPath.row + 1, forKey: Keys.niOrder)
        
        delegateSave()
    }
    
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteItem = noteItemArray_sorted[indexPath.row]
        
        // MARK: textBlock
        if noteItem.value(forKey: Keys.niType) as! String == Block.textBlock {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Block.textBlock, for: indexPath) as! TVTextBlock
            
            cell.delegate = self
            cell.textView.text = noteItem.noteItemText
            // cell.textView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            // cell.contentBlock.frame = CGRect.offsetBy(textview)
            
            
            cell.textChanged { [weak self, weak tableView] (newText: String) in
                guard let self = self else { return }
                noteItem.noteItemText = newText
                
                self.indexOfBlock = indexPath.row
                self.getText(text: newText, noteListTB: self.noteListTB)
                
                DispatchQueue.main.async {
                    tableView?.beginUpdates()
                    tableView?.endUpdates()
                }
               
            }
            
            print("DEBUG TEXT \(noteItem.noteItemOrder)")
            
            return cell
            
            // MARK: titleBlock
        } else if noteItem.value(forKey: Keys.niType) as! String == Block.titleBlock {
            let cell = tableView.dequeueReusableCell(withIdentifier: Block.titleBlock, for: indexPath) as! TVTitleBlock
            
            cell.delegate = self
            cell.titleTextView.text = noteItem.noteItemText
            // cell.titleTextView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            
            cell.textChanged { [weak self, weak tableView] (newText: String) in
                guard let self = self else { return }
                noteItem.noteItemText = newText
                
                self.indexOfBlock = indexPath.row
                self.getText(text: newText, noteListTB: self.noteListTB)
                
                DispatchQueue.main.async {
                    tableView?.beginUpdates()
                    tableView?.endUpdates()
                }
            }
            
            print("DEBUG TITLE \(noteItem.noteItemOrder)")
            
            return cell
            
            // MARK: - photoBlock
        } else if noteItem.value(forKey: Keys.niType) as! String == Block.photoBlock {
            let cell = tableView.dequeueReusableCell(withIdentifier: Block.photoBlock, for: indexPath) as! TVPhotoBlock
            
            cell.downloadImage(for: noteItem) { [weak tableView] image in
                DispatchQueue.main.async {
                    tableView?.beginUpdates()
                    cell.imageBlock.image = image
                    tableView?.endUpdates()
                    
                }
            }
            
            // width 330, height 270
            cell.imageBlock.frame = CGRect(x: 0, y: 0, width: 330, height: 300)
            cell.frame = CGRect(x: 0, y: 0, width: 330, height: 300)
            
            print("DEBUG PHOTO \(noteItem.noteItemOrder)")
            return cell
            
            // MARK: - spaceBlock
        } else if noteItem.value(forKey: Keys.niType) as! String == Block.spaceBlock {
            let cell = tableView.dequeueReusableCell(withIdentifier: Block.spaceBlock, for: indexPath) as! TVSpaceBlock
            
            print("DEBUG LINE \(noteItem.noteItemOrder)")
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - Delete block
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // ---------save the number of deleting block
        // ---------delete block
        // compare this number with the blocks that are higher than him
        // for every block than is higher - make them lower by 1
        var deletingBlocksOrder: Int = 0
        
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainerOffline.viewContext
            
            deletingBlocksOrder = indexPath.row + 1
            
            note.removeObject(value: noteItemArray_sorted[indexPath.row], forKey: Keys.nItems)

            for block in noteItemArray_sorted {
                if block.value(forKey: Keys.niOrder) as! Int >= deletingBlocksOrder {
                    let value = block.value(forKey: Keys.niOrder) as! Int - 1
                    block.setValue(value, forKey: Keys.niOrder)
                }
            }
            //update sorted array of block:
            sortAndUpdate()
            // now I need to update the tableView:
            // noteListTB.reloadData()
            
            do {
                if managedContext.hasChanges {
                    try managedContext.save()
                    self.noteListTB.performBatchUpdates({
                        self.noteListTB.deleteRows(at: [IndexPath(row: deletingBlocksOrder - 1, section: 0)], with: .automatic)
                    }, completion: nil)
                }
            } catch {
                print("Something wrong on deleting the block")
            }
        }
    }
    
}


