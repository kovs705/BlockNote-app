//
//  DetailVCViewController.swift
//  BlockNote app
//
//  Created by Kovs on 25.03.2022.
//

import UIKit
import CoreData
import SwiftUI

class DetailVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var groupType = GroupType()
    var noteObject = Note()
    
    let segueToNoteView = "showNoteView"

    // MARk: - did load
    override func viewDidLoad() {
        super.viewDidLoad()

        title = groupType.groupName ?? "Unknown"
        
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        
    }

}

// MARK: - UITableView
extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupType.typesOfNoteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        cell.textLabel?.text = "\(groupType.typesOfNoteArray[indexPath.row].wrappedNoteName)    \(groupType.typesOfNoteArray[indexPath.row].noteID)"
        cell.textLabel?.textAlignment = .center
        
        cell.backgroundColor = UIColor(named: "DarkBackground")
        return cell
    }
    
    // make a segue to the NoteView:
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteObject = groupType.typesOfNoteArray[indexPath.row]
        
        performSegue(withIdentifier: segueToNoteView, sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToNoteView {
            let noteDetailVC = segue.destination as? C1NoteView
            noteDetailVC?.noteType = noteObject
        }
    }
    
    
    
    
}
