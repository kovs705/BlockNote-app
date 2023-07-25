//
//  C3NoteDetailVC.swift
//  BlockNote app
//
//  Created by Kovs on 15.07.2023.
//

import UIKit

class C3NoteDetailVC: UIViewController {
    
    // MARK: - Properties
    var noteItemArray_sorted: [NoteItem] = []
    var deletingBlocksOrder: Int = 0
    
    var imagePicker: UIImagePickerController!
    var isLargeHidden = false
    
    var textForTextlock: String = ""
    
    var indexOfBlock = 0
    
    var addBlockButton = dockButton(fontSize: 20, icon: Icons.addGroup, color: .systemGray4)
    let textDockButton = dockTextButton(frame: .zero)
    
    @IBOutlet weak var noteListTB: UITableView!
    let notificationCenter = NotificationCenter.default
    
    var presenter: C3NoteDetailPresenterProtocol!
    
    
    // MARK: - UI properties
    let padding: CGFloat = 10
    
    lazy var contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .horizontal
        contentView.distribution = .fill
        contentView.spacing = 10
        contentView.backgroundColor = .systemGray6
        
        return contentView
    }()
    
    lazy var dock: UIView = {
       let dock = UIView()
        dock.backgroundColor = .systemGray6
        dock.translatesAutoresizingMaskIntoConstraints = false
        return dock
    }()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        presenter.sortAndUpdate()
        configureTableView()
        
        title = presenter.note?.wrappedNoteName
        
        let addBlockButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        self.navigationItem.rightBarButtonItem = addBlockButton
        
         notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
         notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureDock()
        
        noteListTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tapGesture.cancelsTouchesInView = false
            noteListTB.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Other funcs
    
    
    
    // MARK: - UI func
    func configureTableView() {
        noteListTB.delegate = self
        noteListTB.dataSource = self
        noteListTB.dragDelegate = self
        noteListTB.dragInteractionEnabled = true
        noteListTB.sectionHeaderHeight = 100
        
        noteListTB.backgroundColor = .blue
        // noteListTB.register(UINib(nibName: "NewPhotoBlock", bundle: nil), forCellReuseIdentifier: NewPhotoBlock.newPhotoBlockID)
    }
    
    func configureDock() {
        view.addSubview(dock)
        
        NSLayoutConstraint.activate([
            dock.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dock.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dock.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dock.widthAnchor.constraint(equalToConstant: view.bounds.width),
            dock.heightAnchor.constraint(equalToConstant: 80)
            
        ])
        
        // placing contentView - UIStackView
        dock.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: dock.topAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: dock.leadingAnchor, constant: padding*2),
            contentView.trailingAnchor.constraint(equalTo: dock.trailingAnchor, constant: -(padding*2)),
            contentView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // placing text buttons:
        contentView.addArrangedSubview(addBlockButton)
        contentView.addArrangedSubview(textDockButton)
    }
    
    
    // MARK: - Objc funcs
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
    

    @objc func addBlock() {
        let alert = UIAlertController(title: "New block", message: "Choose your block", preferredStyle: .actionSheet)
        
        let saveTitleBlock = UIAlertAction(title: "Header", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.presenter.save(blockType: Block.titleBlock, theCase: .title, pickedImage: nil)
        }
        
        let saveTextBlock = UIAlertAction(title: "Text", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.presenter.save(blockType: Block.textBlock, theCase: .text, pickedImage: nil)
        }
        
        let saveSpaceBlock = UIAlertAction(title: "Spacer", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.presenter.save(blockType: Block.spaceBlock, theCase: .space, pickedImage: nil)
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
    
    @objc func showPhotoPicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true)
    }
    
}


// MARK: - Protocol
extension C3NoteDetailVC: C3NoteDetailViewProtocol {
    
    func beginEndUpdates() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.noteListTB.beginUpdates()
            self.noteListTB.endUpdates()
        }
    }
    
    func performBatchUpdates(at insertRow: Int) {
        noteListTB.performBatchUpdates({
            noteListTB.insertRows(at: [IndexPath(row: insertRow - 1, section: 0)], with: .automatic)
        }, completion: nil)
    }
    
    func performDeleteUpdates(at deleteRow: Int) {
        noteListTB.performBatchUpdates({
            noteListTB.deleteRows(at: [IndexPath(row: deleteRow - 1, section: 0)], with: .automatic)
        }, completion: nil)
    }
    
}


// MARK: - ImagePicker
// TODO: Гав, make a cell with up to 3-4 photos with a fixed size
extension C3NoteDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("closed")
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        presenter.save(blockType: Block.photoBlock, theCase: .photo, pickedImage: pickedImage)
        
        picker.dismiss(animated: true)

        dismiss(animated: true, completion: nil)
        
    }
    
}


// MARK: - UITableView
extension C3NoteDetailVC: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let noteItem = noteItemArray_sorted[indexPath.row]
        
        if noteItem.value(forKey: Keys.niType) as! String == Block.textBlock {
            return noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width-40, font: UIFont.systemFont(ofSize: 17))
            
        } else if noteItem.value(forKey: Keys.niType) as! String == Block.titleBlock {
            return noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width-40, font: UIFont.systemFont(ofSize: 22, weight: .bold))
            
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
    
    // MARK: - Move row
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
        
        presenter.delegateSave()
    }
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                self.indexOfBlock = indexPath.row
                
                tableView?.performBatchUpdates({
                    cell.label.text = newText
                    self.presenter.getText(text: newText, noteListTB: self.noteListTB)
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
                self.indexOfBlock = indexPath.row
                
                tableView?.performBatchUpdates({
                    cell.label.text = newText
                    self.presenter.getText(text: newText, noteListTB: self.noteListTB)
                })
            }
            
            print("DEBUG TITLE \(noteItem.noteItemOrder)")
            
            return cell
            
            // MARK: - photoBlock
        } else if noteItem.value(forKey: Keys.niType) as! String == Block.photoBlock {
            let cell = tableView.dequeueReusableCell(withIdentifier: Block.photoBlock, for: indexPath) as! TVPhotoBlock
            
            cell.downloadImage(for: noteItem) { [weak tableView] image in
                tableView?.performBatchUpdates({
                    cell.imageBlock.image = image
                })
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
        if editingStyle == .delete {
            print("it will delete \(indexPath.row)")
            presenter.deleteblock(noteListTB: noteListTB, at: indexPath)
        }
    }
}
