//
//  C3NoteDetailVC.swift
//  BlockNote app
//
//  Created by Kovs on 15.07.2023.
//

import UIKit

class C3NoteDetailVC: UIViewController {

    // MARK: - Properties
    var deletingBlocksOrder: Int = 0

    var imagePicker: UIImagePickerController!

    var textForTextlock: String = ""
    
    var keyboardIsOpened = false

    var addBlockButton = dockButton(fontSize: 20, icon: Icons.addGroup, color: .systemGray4)
    let textDockButton = dockTextButton(frame: .zero)
    var thinStatusBar = UIVisualEffectView()
    let heightForStatusBar: CGFloat = 55

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

    lazy var backbutton: UIButton = {
       let backButton = UIButton()
        backButton.cornerRadius = 15
        backButton.backgroundColor = .systemGray6
        backButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIHelper.giveConfigForImage(size: 18, weight: .medium)), for: .normal)

        return backButton
    }()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        presenter.sortAndUpdate()
        configureTableView()

        title = presenter.note?.wrappedNoteName
        configureDockButtons()

        let addBlockButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        self.navigationItem.rightBarButtonItem = addBlockButton

         notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
         notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        configureDock()
        configureBackButton()
        configureStatusBar()

        noteListTB.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 160, right: 0)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tapGesture.cancelsTouchesInView = false
            noteListTB.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.backbutton.layer.opacity = 1
        }
    }
    
    // MARK: - UI funcs
    func configureTableView() {
        noteListTB.delegate = self
        noteListTB.dataSource = self
        noteListTB.dragDelegate = self
        noteListTB.dragInteractionEnabled = true
        noteListTB.sectionHeaderHeight = 100
        // noteListTB.register(UINib(nibName: "NewPhotoBlock", bundle: nil), forCellReuseIdentifier: NewPhotoBlock.newPhotoBlockID)
    }

    func configureStatusBar() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        view.addSubviews(thinStatusBar)
        thinStatusBar.backgroundColor = .clear
        thinStatusBar.effect = blurEffect

        thinStatusBar.snp.makeConstraints { make in
            make.height.equalTo(heightForStatusBar)
            make.width.equalTo(view.snp.width)
            make.top.equalTo(view)
        }
    }
    
    func configureDockButtons() {
        addBlockButton.addTarget(self, action: #selector(addBlock), for: .touchUpInside)
        textDockButton.addTarget(self, action: #selector(createTextBlock), for: .touchUpInside)
    }

    func configureDock() {
        view.addSubviews(dock)

        NSLayoutConstraint.activate([
            dock.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dock.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dock.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            dock.widthAnchor.constraint(equalToConstant: view.bounds.width),
            dock.heightAnchor.constraint(equalToConstant: 80)

        ])

        // placing contentView - UIStackView
        dock.addSubviews(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: dock.topAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: dock.leadingAnchor, constant: padding * 2),
            contentView.trailingAnchor.constraint(equalTo: dock.trailingAnchor, constant: -(padding * 2)),
            contentView.heightAnchor.constraint(equalToConstant: 40)
        ])

        // placing text buttons:
        contentView.addArrangedSubview(addBlockButton)
        contentView.addArrangedSubview(textDockButton)
    }

    func configureBackButton() {
        view.addSubviews(backbutton)

        NSLayoutConstraint.activate([
            backbutton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backbutton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backbutton.heightAnchor.constraint(equalToConstant: 35),
            backbutton.widthAnchor.constraint(equalToConstant: 35)
        ])

        backbutton.addTarget(self, action: #selector(dismissIt), for: .touchUpInside)
    }

    // MARK: - Objc funcs
    @objc func dismissIt() {
        dismiss(animated: true)
    }

    @objc func handleTap(_ gRecognizer: UITapGestureRecognizer) {
        let tapLocation = gRecognizer.location(in: noteListTB)
        if noteListTB.indexPathForRow(at: tapLocation) == nil {
            // TODO: - Outside of the cell
            if presenter.indexOfBlock != 0 {
                let index = IndexPath(row: presenter.indexOfBlock - 1, section: 0)
                guard let textBlockCell = noteListTB.cellForRow(at: index) as? TVTextBlock else {
                    guard let titleBlockCell = noteListTB.cellForRow(at: index) as? TVTitleBlock else {
                        return
                    }
                    titleBlockCell.textView.resignFirstResponder()
                    return
                }
                textBlockCell.textView.resignFirstResponder()
            }
        }
    }

    // MARK: - Keyboard adjuster
    @objc func adjustForKeyboard(notification: Notification) {

        if notification.name == UIResponder.keyboardWillHideNotification {
            keyboardIsOpened = false
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35, delay: 0, animations: { [weak self] in
                    guard let self = self else { return }
                    self.noteListTB.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 160, right: 0)
                })
            }

        } else {
            keyboardIsOpened = true
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35, delay: 0, animations: { [weak self] in
                    guard let self = self else { return }
                    self.noteListTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: notification.keyboardHeight + self.view.safeAreaInsets.bottom, right: 0)
                })
            }

        }

        noteListTB.scrollIndicatorInsets = noteListTB.contentInset
    }

    // MARK: - create text block and start typing in the new block
    @objc func createTextBlock() {
        presenter.createBlock()
        
        noteListTB.performBatchUpdates {
            if presenter.noteItemArray_sorted.isEmpty {
                presenter.save(blockType: Block.titleBlock, theCase: .title, pickedImage: nil, at: presenter.indexOfBlock)
            } else {
                presenter.save(blockType: Block.textBlock, theCase: .text, pickedImage: nil, at: presenter.indexOfBlock)
            }
        }
        
        startTyping(from: presenter.indexOfBlock - 1)
    }
    
    // MARK: - Add block
    @objc func addBlock() {
        let alert = UIAlertController(title: "New block", message: "Choose your block", preferredStyle: .actionSheet)
        
        let saveTitleBlock = UIAlertAction(title: "Header", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.save(blockType: Block.titleBlock, theCase: .title, pickedImage: nil, at: presenter.noteItemArray_sorted.count)
        }

        let saveTextBlock = UIAlertAction(title: "Text", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.save(blockType: Block.textBlock, theCase: .text, pickedImage: nil, at: presenter.noteItemArray_sorted.count)
        }

        let saveSpaceBlock = UIAlertAction(title: "Spacer", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.save(blockType: Block.spaceBlock, theCase: .space, pickedImage: nil, at: presenter.noteItemArray_sorted.count)
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
            noteListTB.insertRows(at: [IndexPath(row: insertRow, section: 0)], with: .automatic)
        }, completion: nil)
    }

    func performDeleteUpdates(at deleteRow: Int) {
        noteListTB.performBatchUpdates({
            noteListTB.deleteRows(at: [IndexPath(row: deleteRow - 1, section: 0)], with: .automatic)
        }, completion: nil)
    }
    
    func startTyping(from row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        let cell = noteListTB.cellForRow(at: indexPath) as? TVTextBlock
        cell?.textView.becomeFirstResponder()
    }

}

// MARK: - ImagePicker
// TODO: Гав, make a cell with up to 3-4 photos with a fixed size
extension C3NoteDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("closed")
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let pickedImage = info[.originalImage] as? UIImage else {
            return
        }

        presenter.save(blockType: Block.photoBlock, theCase: .photo, pickedImage: pickedImage, at: presenter.noteItemArray_sorted.count)

        picker.dismiss(animated: true)

    }

}

// MARK: - UITableView Scroll
extension C3NoteDetailVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.backbutton.layer.opacity = 1
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.backbutton.layer.opacity = 0

            }
        }
        
        if scrollView.contentOffset.y >= 1 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.thinStatusBar.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.thinStatusBar.alpha = 0.0
            }
        }
    }
}

// MARK: - UITableView
extension C3NoteDetailVC: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let noteItem = presenter.noteItemArray_sorted[indexPath.row]

        if noteItem.value(forKey: Keys.niType) as! String == Block.textBlock {
            return presenter.noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width - 40, font: UIFont.systemFont(ofSize: 17))

        } else if noteItem.value(forKey: Keys.niType) as! String == Block.titleBlock {
            return presenter.noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width - 40, font: UIFont.systemFont(ofSize: 22, weight: .bold))

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
        return presenter.noteItemArray_sorted.count
    }

    // MARK: - Drag&Drop UITableView
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = presenter.noteItemArray_sorted[indexPath.row]
        return [dragItem]
    }

    // MARK: - Move row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let mover = presenter.noteItemArray_sorted.remove(at: sourceIndexPath.row)
        presenter.noteItemArray_sorted.insert(mover, at: destinationIndexPath.row)

        for block in self.presenter.noteItemArray_sorted {
            let blockIndex = block.noteItemOrder - 1
            print(blockIndex)
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
        let noteItem = presenter.noteItemArray_sorted[indexPath.row]

        guard let type = noteItem.value(forKey: Keys.niType) as? String else {
            return UITableViewCell()
        }

        switch type {
            // MARK: - Text
        case Block.textBlock:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Block.textBlock, for: indexPath) as? TVTextBlock else {
                return UITableViewCell()
            }

            cell.loadText(for: noteItem) { [weak tableView] string in
                UIView.performWithoutAnimation {
                    tableView?.performBatchUpdates({
                        cell.textView.text = string
                        cell.label.text = string
                    })
                }
            }
            
            cell.beginEditing = { [weak self] in
                guard let self = self else { return }
                presenter.indexOfBlock = indexPath.row + 1
            }

            cell.textChanged { [weak self, weak tableView] (newText: String) in
                guard let self = self else { return }
                noteItem.noteItemText = newText
                presenter.indexOfBlock = indexPath.row
                
                UIView.performWithoutAnimation {
                    tableView?.performBatchUpdates({
                        cell.label.text = newText
                        self.presenter.getText(text: newText, noteListTB: self.noteListTB)
                    })
                }
            }

            print("DEBUG TEXT \(noteItem.noteItemOrder)")
            return cell

            // MARK: - Title
        case Block.titleBlock:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Block.titleBlock, for: indexPath) as? TVTitleBlock else {
                return UITableViewCell()
            }

            cell.loadText(for: noteItem) { [weak tableView] string in
                tableView?.performBatchUpdates({
                    cell.textView.text = string
                    cell.label.text = string
                })
            }
            
            cell.beginEditing = { [weak self] in
                guard let self = self else { return }
                presenter.indexOfBlock = indexPath.row + 1
            }

            cell.textChanged { [weak self, weak tableView] (newText: String) in
                guard let self = self else { return }
                noteItem.noteItemText = newText
                presenter.indexOfBlock = indexPath.row
                
                tableView?.performBatchUpdates({
                    cell.label.text = newText
                    self.presenter.getText(text: newText, noteListTB: self.noteListTB)
                })
            }

            print("DEBUG TITLE \(noteItem.noteItemOrder)")
            return cell

            // MARK: - Photo
        case Block.photoBlock:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Block.photoBlock, for: indexPath) as? TVPhotoBlock else {
                return UITableViewCell()
            }

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

            // MARK: - Space
        case Block.spaceBlock:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Block.spaceBlock, for: indexPath) as? TVSpaceBlock else {
                return UITableViewCell()
            }

            print("DEBUG LINE \(noteItem.noteItemOrder)")
            return cell
        default:
            return UITableViewCell()
        }
    }

    // MARK: - Delete block
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // ---------save the number of deleting block
        // ---------delete block
        // compare this number with the blocks that are higher than him
        // for every block than is higher - make them lower by 1
        if editingStyle == .delete {
            presenter.deleteblock(noteListTB: noteListTB, at: indexPath)
        }
    }
}
