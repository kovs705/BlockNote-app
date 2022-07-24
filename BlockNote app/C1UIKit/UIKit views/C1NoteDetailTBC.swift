//
//  C1DetailTBC.swift
//  BlockNote app
//
//  Created by Kovs on 24.05.2022.
//

import UIKit
import CoreData
// import RxSwift
// import RxCocoa

class C1NoteDetailTBC: UITableViewController, textSaveDelegate {
    
    @IBOutlet var noteListTB: UITableView!
    // let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: C1NoteDetailTBC.self, action: #selector(backSaveChanging))
    
    lazy var note = Note()
    var noteItemArray_sorted: [NoteItem] = []
    
    var imagePicker: UIImagePickerController!
    
    @Published var getNote = "value"
    
    // RxSwift: future thing, I guess
    // var db = DisposeBag()
    
    // block types:
    let textBlock = "TextBlock"
    let photoBlock = "PhotoBlock"
    
    var textForTextlock: String = ""
    var updateBool: Bool = false
    let cellSpacingHeight: CGFloat = 50
    
    var indexOfBlock = 0
    // var editingBool = false
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Global
        // navigationItem.leftBarButtonItem = backButton
        
        // TODO: Put this in viewWillAppear?
        sortAndUpdate()
        
        noteListTB.delegate = self
        noteListTB.dataSource = self
        
        print("Number of blocks: \(noteItemArray_sorted.count)")
        
        self.noteListTB.sectionHeaderHeight = 50
        
        // Navigation
        title = note.wrappedNoteName
        
        // Debug
        // print("\(noteItemArray_sorted.count)")
        
        /// Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        /// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let addBlockButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        self.navigationItem.rightBarButtonItem = addBlockButton
        
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        // navigationController?.navigationBar.prefersLargeTitles = true
        
        sortAndUpdate()
        noteListTB.reloadData()
        for item in noteItemArray_sorted {
            print("\(item.noteItemOrder) ")
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let noteItem = noteItemArray_sorted[indexPath.row]
        
        if noteItem.value(forKey: "noteItemType") as! String == textBlock {
            return noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width-60, font: UIFont.systemFont(ofSize: 17))
            
        } else if noteItem.value(forKey: "noteItemType") as! String == photoBlock {
            let image = UIImage(data: noteItem.noteItemPhoto!)
            let imageCrop = image!.getCropRatio()
            return tableView.frame.width / imageCrop
        } else {
            return 250
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteItemArray_sorted.count
    }
    
    
    // mARK: - Header
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteItem = noteItemArray_sorted[indexPath.row]
        
        if noteItem.value(forKey: "noteItemType") as! String == textBlock {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: textBlock, for: indexPath) as! TVTextBlock
            
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
            return cell
            
        } else if noteItem.value(forKey: "noteItemType") as! String == photoBlock {
            let cell = tableView.dequeueReusableCell(withIdentifier: photoBlock, for: indexPath) as! TVPhotoBlock
            cell.imageBlock.image = UIImage(data: noteItem.noteItemPhoto!)
            
            // width 330, height 270
            cell.imageBlock.frame = CGRect(x: 0, y: 0, width: 330, height: 270)
            cell.frame = CGRect(x: 0, y: 0, width: 330, height: 270)
            
            print("order of this photo is \(noteItem.value(forKey: "noteItemOrder") as! Int)")
            return cell
        }
        return UITableViewCell()
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    
    
    

    
    
    // MARK: - Sort and update
    func sortAndUpdate() {
        /// made for reuse multiple times to update sorted array of
        //TODO: make a switch for other objects in CoreData, (make a reusable public func)
        noteItemArray_sorted = note.noteItemArray.sorted {
            $0.noteItemOrder < $1.noteItemOrder
        }
        // noteListTB.reloadData()
    }
    
    // MARK: - Add photo block
    @objc func showPhotoPicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }
    
    // MARK: - Add text block
    @objc func addBlock() {
        let alert = UIAlertController(title: "New block", message: "Choose your block", preferredStyle: .actionSheet)
        
        // textBlock save
        let saveTextBlock = UIAlertAction(title: "Text", style: .default) { [unowned self] action in
            
//            guard
//                // let textField = alert.textFields?.first,
//                // let blockToSave = textField.text
//            else {
//                return
//            }
            let blockToSave = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. MEOW"
            
            self.save(blockType: textBlock, blockText: blockToSave)
            // self.groupCollection.reloadData()
        }
        
        // photoBlock save
        let savePhotoBlock = UIAlertAction(title: "Photo", style: .default) { [unowned self] action in
            self.showPhotoPicker()
        }
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // alert.addTextField()
        alert.addAction(saveTextBlock)
        alert.addAction(savePhotoBlock)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        
    }
    
    // MARK: - keyboard detect (work in progress)
//    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
//        guard let key = presses.first?.key else { return }
//
//        switch key.keyCode {
//        case .keyboardReturnOrEnter:
//            saveAndStartTyping()
//        default:
//            super.pressesEnded(presses, with: event)
//        }
//    }
    
   // MARK: - Func to create a new textBlock by clicking on return button + make the last block (this text block) as a first responder and start typing there:
    func saveAndStartTyping() {
        print("You tapped return button on keyboard")
        save(blockType: textBlock, blockText: "New text")
        
        if let lastBlock = noteItemArray_sorted.last?.noteItemOrder {
            let cell = noteListTB.dequeueReusableCell(withIdentifier: textBlock, for: IndexPath(index: lastBlock)) as! TVTextBlock
            cell.textView.becomeFirstResponder()
        } else {
            return
        }
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainerOffline.viewContext
        
/// update the date of the last changing
        block?.setValue(Date(), forKey: "lastChangedNI")
/// update the text of the block
        block?.setValue(blockText, forKey: "noteItemText")
        
        do {
            if managedContext.hasChanges {
                // backSaveChanging()
                try managedContext.save()
            } else {
                print("Wrong on updating the note item")
            }
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
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
        
        blockItem.setValue(blockType, forKey: "noteItemType")
        blockItem.setValue(blockText, forKey: "noteItemText")
        
        if noteItemArray_sorted.isEmpty {
            blockItem.setValue(1, forKey: "noteItemOrder")
        } else {
            blockItem.setValue((note.noteItemArray.last?.noteItemOrder ?? 0) + 1, forKey: "noteItemOrder")
        }
        
        do {
            
            note.addObject(value: blockItem, forKey: "noteItems")
            
            if managedContext.hasChanges {
                print("Successfully added")
                sortAndUpdate()
                try managedContext.save()
            } else {
                print("Something wrong on saving block. No changes? No bitches?")
            }
            
            // check for changes in sorted array:
            if note.noteItems?.count == noteItemArray_sorted.count {
                
                print("Same numbers of note")
                
                self.noteListTB.performBatchUpdates({
                    self.noteListTB.insertRows(at: [IndexPath(row: noteItemArray_sorted.count - 1, section: 0)], with: .automatic)
                }, completion: nil)
                
                print("Updated rows")
                DispatchQueue.main.async {
                    self.noteListTB.beginUpdates()
                    self.noteListTB.endUpdates()
                }
            } else {
                sortAndUpdate()
                print("notes: \(note.noteItems?.count ?? 0) === sortedNotes: \(noteItemArray_sorted.count)")
                print("YO, NO CHANGES, UPDATE SORTED ARRAY!")
                
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
            note.removeObject(value: noteItemArray_sorted[indexPath.row], forKey: "noteItems")
            // we deleted, but nothing happens on tableView, so before the animations begin, I need to change order numbers to reorder them again:
            for block in noteItemArray_sorted {
                if block.value(forKey: "noteItemOrder") as! Int >= deletingBlocksOrder {
                    let value = block.value(forKey: "noteItemOrder") as! Int - 1
                    block.setValue(value, forKey: "noteItemOrder")
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

// MARK: - Photo block and ImagePicker extension
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

//        guard let jpegImage = pickedImage.jpegData(compressionQuality: 1.0) else {
//            return
//        }
        // image = jpegImage
        
        // pickedImage.toData as NSData?

//        do {
//            image = try NSKeyedArchiver.archivedData(withRootObject: image! as Data, requiringSecureCoding: true)
//        } catch {
//            print("error")
//        }
        
        
        blockItem.setValue(photoBlock, forKey: "noteItemType")

        blockItem.setValue(pickedImage.toData as NSData?, forKey: "noteItemPhoto")
        blockItem.setValue(Date(), forKey: "lastChangedNI")

        if noteItemArray_sorted.isEmpty {
            blockItem.setValue(1, forKey: "noteItemOrder")
        } else {
                blockItem.setValue((note.noteItemArray.last?.noteItemOrder ?? 0) + 1, forKey: "noteItemOrder")
        }
        
        note.addObject(value: blockItem, forKey: "noteItems")

        do {
            if managedContext.hasChanges {
                print("added a photo")
                try managedContext.save()
                sortAndUpdate()
                picker.dismiss(animated: true)
                
                if note.noteItems?.count == noteItemArray_sorted.count {
                    
                    DispatchQueue.main.async {
                        self.noteListTB.beginUpdates()
                        
                        self.noteListTB.performBatchUpdates({
                            self.noteListTB.insertRows(at: [IndexPath(row: self.noteItemArray_sorted.count - 1, section: 0)], with: .automatic)
                        }, completion: nil)
                        
                        print("Updated rows")
                        
                        self.noteListTB.endUpdates()
                    }
                } else {
                    sortAndUpdate()
                    print("notes: \(note.noteItems?.count ?? 0) === sortedNotes: \(noteItemArray_sorted.count)")
                    print("YO, NO CHANGES, UPDATE SORTED ARRAY!")
                    
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
            } else {
                print("Okay, the image has not been saved")
            }
        } catch {
            print("Okay, it crashed, lul")
        }
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
