//
//  C1DetailTBC.swift
//  BlockNote app
//
//  Created by Kovs on 24.05.2022.
//

import UIKit
import CoreData
import SwiftUI
// import RxSwift
// import RxCocoa

// MARK: - Class and properties
class C1NoteDetailTBC: UITableViewController, textSaveDelegate, titleSaveDelegate, UITableViewDragDelegate {
    
    @IBOutlet var noteListTB: UITableView!
    // let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: C1NoteDetailTBC.self, action: #selector(backSaveChanging))
    
    lazy var note = Note()
    lazy var textView = UITextView()
    var noteItemArray_sorted: [NoteItem] = []
    
    var imagePicker: UIImagePickerController!
    
    @Published var getNote = "value"
    var isLargeHidden = false
    
    // RxSwift: future thing, I guess
    // var db = DisposeBag()
    
    var textForTitleBlock: String = ""
    var textForTextlock: String = ""
    
    var updateBool: Bool = false
//    let cellSpacingHeight: CGFloat = 100
    
    var indexOfBlock = 0
    // var editingBool = false
    let baseImage = UIImage(named: "gav")!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Global
        // navigationItem.leftBarButtonItem = backButton
        
        // TODO: Put this in viewWillAppear?
        sortAndUpdate()
        
        noteListTB.delegate = self
        noteListTB.dataSource = self
        // drag&drop:
        noteListTB.dragDelegate = self
        noteListTB.dragInteractionEnabled = true
        
        self.noteListTB.sectionHeaderHeight = 100
        
        
        // Navigation
        title = note.wrappedNoteName
        
        /// Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        let addBlockButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        self.navigationItem.rightBarButtonItem = addBlockButton
        
        
//        textView.text = note.wrappedNoteName
//        textView.font = .systemFont(ofSize: 25, weight: .bold)
//        textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
//
//        navigationItem.titleView = textView
        
    }
    
    // MARK: - viewWillAppear
    //    override func viewWillAppear(_ animated: Bool) {
    //        // navigationController?.navigationBar.prefersLargeTitles = true
    //
    //        // sortAndUpdate()
    //        // noteListTB.reloadData()
    //        for item in noteItemArray_sorted {
    //            print("\(item.noteItemOrder)")
    //        }
    //    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
//    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let titleHeight = textView.bounds.height
//
//        if (scrollView.contentOffset.y <= 0) {
//            // title is fully visible:
//            navigationItem.titleView = textView
//            isLargeHidden = false
//        }
//    }
    
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
        
        delegateSave()
    }
    
    // MARK: - Header
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return cellSpacingHeight
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
//
//                let label = UILabel()
//                label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//                label.text = "Notification Times"
//                label.font = .systemFont(ofSize: 16)
//                label.textColor = .yellow
//
//                headerView.addSubview(label)
//
//                return headerView
//    }

    // MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteItem = noteItemArray_sorted[indexPath.row]
        
        // MARK: textBlock
        if noteItem.value(forKey: Keys.niType) as! String == Block.textBlock {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Block.textBlock, for: indexPath) as! TVTextBlock
            
            cell.delegate = self
            cell.textView.text = noteItem.noteItemText
            cell.textView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            // cell.contentBlock.frame = CGRect.offsetBy(textview)
            
            
            cell.textChanged { [weak tableView] (newText: String) in
                noteItem.noteItemText = newText
                
                self.indexOfBlock = indexPath.row
                self.getText(text: newText)
                
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
            cell.titleTextView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            
            cell.textChanged { [weak tableView] (newText: String) in
                noteItem.noteItemText = newText
                
                self.indexOfBlock = indexPath.row
                self.getTitle(text: newText)
                
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
            
            // cell.imageBlock?.image = UIImage(data: (noteItem.noteItemPhoto ?? baseImage.toData!))
            
            cell.downloadImage(for: noteItem)
            
            // width 330, height 270
            cell.imageBlock.frame = CGRect(x: 0, y: 0, width: 330, height: 300)
            cell.frame = CGRect(x: 0, y: 0, width: 330, height: 300)
            
            // print("order of this photo is \(noteItem.value(forKey: "noteItemOrder") as! Int)")
            print("DEBUG PHOTO \(noteItem.noteItemOrder)")
            return cell
        } else if noteItem.value(forKey: Keys.niType) as! String == Block.spaceBlock {
            let cell = tableView.dequeueReusableCell(withIdentifier: Block.spaceBlock, for: indexPath) as! TVSpaceBlock
            
            print("DEBUG LINE \(noteItem.noteItemOrder)")
            return cell
        }
        return UITableViewCell()
    }
    
//    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }
    
    
    
    
    

    
    
    // MARK: - Sort and update
    func sortAndUpdate() {
        /// made for reuse multiple times to update sorted array of
        //TODO: make a switch for other objects in CoreData, (make a reusable public func)
        noteItemArray_sorted = note.noteItemArray.sorted {
            $0.noteItemOrder < $1.noteItemOrder
        }
        // noteListTB.reloadData()
        // noteListTB.endEditing(true)
        print("=========\nNumber of blocks: \(noteItemArray_sorted.count)")
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
        
        // textBlock save
        
        let saveTitleBlock = UIAlertAction(title: "Header", style: .default) { [weak self] action in
            guard let self = self else { return }
            let titleToSave = "Lorem ipsum title"
            
            self.save(blockType: Block.titleBlock, blockText: titleToSave)
        }
        
        let saveTextBlock = UIAlertAction(title: "Text", style: .default) { [weak self] action in
            guard let self = self else { return }
            let blockToSave = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. MEOW"
            
            self.save(blockType: Block.textBlock, blockText: blockToSave)
            // self.groupCollection.reloadData()
        }
        
        let saveSpaceBlock = UIAlertAction(title: "Spacer", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.saveSpaceLine()
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
        save(blockType: Block.textBlock, blockText: "New text")       // saves a new block
        
        DispatchQueue.main.async {
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
    
    // MARK: - Get text
    func getText(text: String?) {
        
        textForTextlock = text ?? "Nothing in the text, or it's just the bug."
        update(blockText: textForTextlock, block: self.noteItemArray_sorted[indexOfBlock])
        // print("you changed the block with the index of \(indexOfBlock)")
    }
    
    // MARK: - update block
    func update(blockText: String, block: NoteItem?) {
        
/// update the date of the last changing
        block?.setValue(Date(), forKey: Keys.niLastChanged)
/// update the text of the block
        block?.setValue(blockText, forKey: Keys.niText)
        
        delegateSave()
    }
    
    // MARK: - Save block
    func save(blockType: String, blockText: String) {
        // var newNumberOfNotes = 0
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        let managedContext =
        appDelegate.persistentContainerOffline.viewContext
        
        let entity =
        NSEntityDescription.entity(forEntityName: "NoteItem",
                                   in: managedContext)!
        
        let blockItem = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        
        blockItem.setValue(blockType, forKey: Keys.niType)
        blockItem.setValue(blockText, forKey: Keys.niText)
        blockItem.setValue(Date(), forKey: Keys.niLastChanged)
        
        // MARK: - Give an order number for note:
        if noteItemArray_sorted.isEmpty {
            blockItem.setValue(1, forKey: Keys.niOrder)
        } else {
            blockItem.setValue(noteItemArray_sorted.count + 1, forKey: Keys.niOrder)
//            if note.noteItemArray.last?.noteItemType == photoBlock {
//                noteListTB.reloadData()
//                noteItemArray_sorted
//            }
        }
        
        do {
            
            note.addObject(value: blockItem, forKey: Keys.nItems)
            
            if managedContext.hasChanges {
                sortAndUpdate()
                try managedContext.save()
            } else {
                print("Something wrong on saving block. No changes? No bitches?")
            }
            
            // check for changes in sorted array:
            if note.noteItems?.count == noteItemArray_sorted.count {
                
                self.noteListTB.performBatchUpdates({
                    self.noteListTB.insertRows(at: [IndexPath(row: noteItemArray_sorted.count - 1, section: 0)], with: .automatic)
                }, completion: nil)
                
                DispatchQueue.main.async {
                    self.noteListTB.beginUpdates()
                    self.noteListTB.endUpdates()
                }
            } else {
                sortAndUpdate()
                print("notes: \(note.noteItems?.count ?? 0) === sortedNotes: \(noteItemArray_sorted.count)")
                
                DispatchQueue.main.async {
                    self.noteListTB.beginUpdates()
                    // noteListTB.reloadRows(at: [indexPath], with: .automatic)
                    self.noteListTB.endUpdates()
                }
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Delete block
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
            
            // remember row
            deletingBlocksOrder = indexPath.row + 1
            // delete block
            note.removeObject(value: noteItemArray_sorted[indexPath.row], forKey: Keys.nItems)
            // we deleted, but nothing happens on tableView, so before the animations begin, I need to change order numbers to reorder them again:
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
    
    func saveSpaceLine() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainerOffline.viewContext
        
        let entity =
        NSEntityDescription.entity(forEntityName: "NoteItem",
                                   in: managedContext)!
        
        let blockItem = NSManagedObject(entity: entity,
                                        insertInto: managedContext)
        
        blockItem.setValue(Block.spaceBlock, forKey: Keys.niType)

        blockItem.setValue(Date(), forKey: Keys.niLastChanged)
        
        if noteItemArray_sorted.isEmpty {
            blockItem.setValue(1, forKey: Keys.niOrder)
        } else {
            blockItem.setValue(noteItemArray_sorted.count + 1, forKey: Keys.niOrder)
        }
        
        do {
            note.addObject(value: blockItem, forKey: Keys.nItems)
            
            if managedContext.hasChanges {
                sortAndUpdate()
                try managedContext.save()
            } else {
                print("Okay, the line has not been saved")
            }
            
            if note.noteItems?.count == noteItemArray_sorted.count {
                
                self.noteListTB.performBatchUpdates({
                    self.noteListTB.insertRows(at: [IndexPath(row: self.noteItemArray_sorted.count - 1, section: 0)], with: .automatic)
                }, completion: nil)
                
                DispatchQueue.main.async {
                    self.noteListTB.beginUpdates()
                    self.noteListTB.endUpdates()
                }
            } else {
                sortAndUpdate()
                print("notes: \(note.noteItems?.count ?? 0) === sortedNotes: \(noteItemArray_sorted.count)")
                
                DispatchQueue.main.async {
                    self.noteListTB.beginUpdates()
                    // noteListTB.reloadRows(at: [indexPath], with: .automatic)
                    self.noteListTB.endUpdates()
                }
            }
        } catch {
            print("Okay, it crashed, lul")
        }
    }
    
    // MARK: - TitleBlock function
    func update(titleText: String, block: NoteItem?) {

/// update the date of the last changing
        block?.setValue(Date(), forKey: Keys.niLastChanged)
/// update the text of the block
        block?.setValue(titleText, forKey: Keys.niText)
        
        delegateSave()
    }
    
    func getTitle(text: String?) {
        textForTitleBlock = text ?? "Nothing in the title, or it's just the bug."
        update(titleText: textForTitleBlock, block: self.noteItemArray_sorted[indexOfBlock])
    }

}

// MARK: - Photo block and ImagePicker extension
    // TODO: Гав, make a cell with up to 3-4 photos with a fixed size
extension C1NoteDetailTBC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("closed")
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // var image: NSData?
        
        // Context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainerOffline.viewContext
        
        let entity =
        NSEntityDescription.entity(forEntityName: "NoteItem",
                                   in: managedContext)!
        
        let blockItem = NSManagedObject(entity: entity,
                                    insertInto: managedContext)

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
        
        
        blockItem.setValue(Block.photoBlock, forKey: Keys.niType)

        blockItem.setValue(pickedImage.toData as NSData?, forKey: Keys.niPhoto)
        blockItem.setValue(Date(), forKey: Keys.niLastChanged)

        if noteItemArray_sorted.isEmpty {
            blockItem.setValue(1, forKey: Keys.niOrder)
        } else {
            blockItem.setValue(noteItemArray_sorted.count + 1, forKey: Keys.niOrder)
        }

        do {
            
            note.addObject(value: blockItem, forKey: Keys.nItems)
            
            if managedContext.hasChanges {
                sortAndUpdate()
                picker.dismiss(animated: true)
                try managedContext.save()
            } else {
                print("Okay, the image has not been saved")
            }
            
            if note.noteItems?.count == noteItemArray_sorted.count {
                
                self.noteListTB.performBatchUpdates({
                    self.noteListTB.insertRows(at: [IndexPath(row: self.noteItemArray_sorted.count - 1, section: 0)], with: .automatic)
                }, completion: nil)
                
                DispatchQueue.main.async {
                    self.noteListTB.beginUpdates()
                    self.noteListTB.endUpdates()
                }
            } else {
                sortAndUpdate()
                print("notes: \(note.noteItems?.count ?? 0) === sortedNotes: \(noteItemArray_sorted.count)")
                
                DispatchQueue.main.async {
                    self.noteListTB.beginUpdates()
                    // noteListTB.reloadRows(at: [indexPath], with: .automatic)
                    self.noteListTB.endUpdates()
                }
            }
            
            //                DispatchQueue.main.async {
            //                    self.noteListTB.beginUpdates()
            //                    // noteListTB.reloadRows(at: [indexPath], with: .automatic)
            //                    self.noteListTB.endUpdates()
            //                }
        } catch {
            print("Okay, it crashed, lul")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

func delegateSave() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainerOffline.viewContext
    
    do {
        if managedContext.hasChanges {
            try managedContext.save()
        } else {
            print("Wrong on updating the note item")
        }
    } catch let error as NSError {
        print("Could not update. \(error), \(error.userInfo)")
    }
}

extension UIImage {
    var toData: Data? {
        return pngData()
    }
    
    func getCropRatio() -> CGFloat {
        let widthRatio = self.size.width / self.size.height
        return widthRatio
    }
}
