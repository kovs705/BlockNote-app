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

class C1NoteDetailTBC: UITableViewController {
    
    @IBOutlet var noteListTB: UITableView!
    
    lazy var note = Note()
    var noteItemArray_sorted: [NoteItem] = []
    var debugNumberOfNotesInSortedArray = 0
    
    // RxSwift: future thing, I guess
    // var db = DisposeBag()
    
    // block types:
    let textBlock = "TextBlock"
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register textBlock cell
        // tableView.register(UINib(nibName: "TVTextBlock", bundle: nil), forCellReuseIdentifier: textBlock)
        
        
        // TODO: Put this in viewWillAppear?
        sortAndUpdate()
        
        debugNumberOfNotesInSortedArray = noteItemArray_sorted.count
        print("Debug number: \(debugNumberOfNotesInSortedArray)")
        
        noteListTB.delegate = self
        noteListTB.dataSource = self
        
        // Navigation
        title = note.wrappedNoteName
        
        // Debug
        print("\(noteItemArray_sorted.count)")
        noteListTB.dataSource = self
        noteListTB.delegate = self
        
        /// Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        /// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let addBlockButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        self.navigationItem.rightBarButtonItem = addBlockButton
        
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return noteItemArray_sorted[indexPath.row].noteItemText
            .heightWithConstrainedWidth(width: tableView.frame.width, font: UIFont.systemFont(ofSize: 14))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteItemArray_sorted.count
    }

    /// commented it to use RxSwift in ViewDidLoad..
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteItem = noteItemArray_sorted[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: textBlock, for: indexPath) as! TVTextBlock

        cell.textView.text = noteItem.noteItemText

        cell.textChanged { [weak tableView] (newText: String) in
            noteItem.noteItemText = newText

            DispatchQueue.main.async {
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
        }
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func sortAndUpdate() {
        /// made for reuse multiple times to update sorted array of
        //TODO: make a switch for other objects in CoreData, (make a reusable public func)
        noteItemArray_sorted = note.noteItemArray.sorted {
            $0.noteItemOrder < $1.noteItemOrder
        }
    }
    
    // MARK: - Add block
    @objc func addBlock() {
        let alert = UIAlertController(title: "New block", message: "Enter some text for block", preferredStyle: .alert)
        
        // save action button
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
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
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        
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
        
        do {
            // note.noteItemArray.insert(blockItem, at: 0)
            note.addObject(value: blockItem, forKey: "noteItems")
            
            // get the number of sorted notes and compare with existing number - if they are the same - update the tableView
            
            
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
//                DispatchQueue.main.async {
//                    self.noteListTB.beginUpdates()
//                    self.noteListTB.endUpdates()
//                }
            } else {
                sortAndUpdate()
                print("notes: \(note.noteItems?.count ?? 0) === sortedNotes: \(noteItemArray_sorted.count)")
                // print("YO, NO CHANGES, UPDATE SORTED ARRAY!")
                
                DispatchQueue.main.async {
                    self.noteListTB.beginUpdates()
                    // noteListTB.reloadRows(at: [indexPath], with: .automatic)
                    self.noteListTB.endUpdates()
                }
            }
            
            
//            noteListTB.beginUpdates()
//            DispatchQueue.main.async { () -> Void in
//                self.noteListTB.reloadData()
//                print("updated, number of sorted rows: \(self.noteItemArray_sorted.count)")
//            }
//            noteListTB.endUpdates()
            
            
            
//            self.noteListTB.beginUpdates()
//            // self.noteListTB.insertRows(at: [IndexPath.init(row: self.noteItemArray_sorted.count + 1, section: 0)], with: .automatic)
//            self.noteListTB.reloadData()
//            self.noteListTB.endUpdates()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
