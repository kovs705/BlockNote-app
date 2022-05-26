//
//  C1DetailTBC.swift
//  BlockNote app
//
//  Created by Kovs on 24.05.2022.
//

import UIKit

class C1NoteDetailTBC: UITableViewController {
    
    @IBOutlet var noteListTB: UITableView!
    
    lazy var note = Note()
    var noteItemArray_sorted: [NoteItem] = []
    
    // block types:
    let textBlock = "TextBlock"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Put this in viewWillAppear?
        noteItemArray_sorted = note.noteItemArray.sorted {
            $0.noteItemOrder < $1.noteItemOrder
        }
        noteListTB.delegate = self
        noteListTB.dataSource = self
        
        // Navigation
        title = note.wrappedNoteName
        
        // Debug
        print("\(noteItemArray_sorted.count)")
        
        /// Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        /// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

}
