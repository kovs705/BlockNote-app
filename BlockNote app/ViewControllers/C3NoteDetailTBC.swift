//
//  C3NoteDetailTBC.swift
//  BlockNote app
//
//  Created by Kovs on 11.04.2023.
//

import UIKit

class C3NoteDetailTBC: C3NoteDetailExt, UITableViewDragDelegate {

    @IBOutlet weak var noteListTB: UITableView!
    let notificationCenter = NotificationCenter.default

    let ext = C3NoteDetailExt.self

    override func viewDidLoad() {
        super.viewDidLoad()

        sortAndUpdate()
        configureTableView()

        title = note.wrappedNoteName

        // let addBlockButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        // self.navigationItem.rightBarButtonItem = addBlockButton

         // notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
         // notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        configureDock(noteListTB)

        noteListTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tapGesture.cancelsTouchesInView = false
            noteListTB.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(_ gRecognizer: UITapGestureRecognizer) {
        let tapLocation = gRecognizer.location(in: noteListTB)
        if noteListTB.indexPathForRow(at: tapLocation) == nil {
            print("Outside of the cell")
        }
    }

    @objc func adjustForKeyboard(notification: Notification) {

        if notification.name == UIResponder.keyboardWillHideNotification {

//            DispatchQueue.main.async {
//                UIView.performWithoutAnimation {
//                    self.noteListTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
//                }
//            }

            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35, delay: 0, animations: { [weak self] in
                    guard let self = self else { return }
                    self.noteListTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
                })
            }

        } else {
//            DispatchQueue.main.async {
//                UIView.performWithoutAnimation {
//                    self.noteListTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: notification.keyboardHeight + self.view.safeAreaInsets.bottom, right: 0)
//                }
//            }

            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35, delay: 0, animations: { [weak self] in
                    guard let self = self else { return }
                    self.noteListTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: notification.keyboardHeight + self.view.safeAreaInsets.bottom, right: 0)
                })
            }

        }

        noteListTB.scrollIndicatorInsets = noteListTB.contentInset
    }

    func configureTableView() {
        noteListTB.delegate = self
        noteListTB.dataSource = self
        noteListTB.dragDelegate = self
        noteListTB.dragInteractionEnabled = true
        noteListTB.sectionHeaderHeight = 100

        // noteListTB.register(UINib(nibName: "NewPhotoBlock", bundle: nil), forCellReuseIdentifier: NewPhotoBlock.newPhotoBlockID)
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

        let saveTitleBlock = UIAlertAction(title: "Header", style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.save(blockType: Block.titleBlock, theCase: .title, noteListTB: self.noteListTB, pickedImage: nil)
        }

        let saveTextBlock = UIAlertAction(title: "Text", style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.save(blockType: Block.textBlock, theCase: .text, noteListTB: self.noteListTB, pickedImage: nil)
        }

        let saveSpaceBlock = UIAlertAction(title: "Spacer", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.save(blockType: Block.spaceBlock, theCase: .space, noteListTB: self.noteListTB, pickedImage: nil)
        }

        // photoBlock save
        let savePhotoBlock = UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
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
        PersistenceBlockController.shared.update(blockText: textForTextlock, block: self.noteItemArray_sorted[ext.indexOfBlock], noteListTB: noteListTB)
        // print("you changed the block with the index of \(indexOfBlock)")
    }

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
extension C3NoteDetailTBC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("closed")
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let pickedImage = info[.originalImage] as? UIImage else {
            return
        }

        save(blockType: Block.photoBlock, theCase: .photo, noteListTB: noteListTB, pickedImage: pickedImage)

        picker.dismiss(animated: true)

        dismiss(animated: true, completion: nil)

    }

// MARK: - UITableView

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let noteItem = noteItemArray_sorted[indexPath.row]

        if noteItem.value(forKey: Keys.niType) as! String == Block.textBlock {
            return noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width - 40, font: UIFont.systemFont(ofSize: 17))

        } else if noteItem.value(forKey: Keys.niType) as! String == Block.titleBlock {
            return noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width - 40, font: UIFont.systemFont(ofSize: 22, weight: .bold))

        } else if noteItem.value(forKey: Keys.niType) as! String == Block.photoBlock {
            let image = UIImage(data: noteItem.noteItemPhoto!)
            let imageCrop = image!.getCropRatio()
            return tableView.frame.width / imageCrop
        } else {
            return 30
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteItemArray_sorted.count
    }

    // MARK: - Drag&Drop UITableView
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = noteItemArray_sorted[indexPath.row]
        return [dragItem]
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
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

        PersistenceBlockController.shared.delegateSave()
    }

    // MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteItem = noteItemArray_sorted[indexPath.row]

        // MARK: textBlock
        if noteItem.value(forKey: Keys.niType) as! String == Block.textBlock {

            let cell = tableView.dequeueReusableCell(withIdentifier: Block.textBlock, for: indexPath) as! TVTextBlock

            cell.loadText(for: noteItem) { [weak tableView] string in
                tableView?.performBatchUpdates({
                    cell.textView.text = string
                    cell.label.text = string
                })
            }

            cell.textChanged { [weak self, weak tableView] (newText: String) in
                guard let self = self else { return }
                noteItem.noteItemText = newText
                self.ext.indexOfBlock = indexPath.row

                tableView?.performBatchUpdates({
                    cell.label.text = newText
                    self.getText(text: newText, noteListTB: self.noteListTB)
                })

//                self.noteListTB.isScrollEnabled = false
//                cell.scrollToLine(cell.textView)
//                self.noteListTB.isScrollEnabled = true

            }

            print("DEBUG TEXT \(noteItem.noteItemOrder)")

            return cell

            // MARK: titleBlock
        } else if noteItem.value(forKey: Keys.niType) as! String == Block.titleBlock {
            let cell = tableView.dequeueReusableCell(withIdentifier: Block.titleBlock, for: indexPath) as! TVTitleBlock

            cell.loadText(for: noteItem) { [weak tableView] string in
                tableView?.performBatchUpdates({
                    cell.textView.text = string
                    cell.label.text = string
                })
            }

            cell.textChanged { [weak self, weak tableView] (newText: String) in
                guard let self = self else { return }
                noteItem.noteItemText = newText
                self.ext.indexOfBlock = indexPath.row

                tableView?.performBatchUpdates({
                    cell.label.text = newText
                    self.getText(text: newText, noteListTB: self.noteListTB)
                })
            }

            print("DEBUG TITLE \(noteItem.noteItemOrder)")

            return cell

            // MARK: - photoBlock
        } else if noteItem.value(forKey: Keys.niType) as! String == Block.photoBlock {
            let cell = tableView.dequeueReusableCell(withIdentifier: Block.photoBlock, for: indexPath) as! TVPhotoBlock

            // animation?
            // width 330, height 270
            cell.imageBlock.frame = CGRect(x: 0, y: 0, width: 330, height: 300)
            cell.frame = CGRect(x: 0, y: 0, width: 330, height: 300)

            DispatchQueue.main.async {
                cell.downloadImage(for: noteItem) { [weak tableView] image in
                    tableView?.performBatchUpdates({
                        UIView.animate(withDuration: 0.2, delay: 0) {
                            cell.imageBlock.image = image
                        }
                    })
                }
            }

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // ---------save the number of deleting block
        // ---------delete block
        // compare this number with the blocks that are higher than him
        // for every block than is higher - make them lower by 1
        if editingStyle == .delete {
            print("it will delete \(indexPath.row)")
            deleteblock(noteListTB: noteListTB, at: indexPath)
        }
    }

}
