//
//  TimeAgendaController.swift
//  BlockNote app
//
//  Created by Kovs on 18.12.2022.
//

import UIKit
import SwiftUI
import CoreData

class AgendaVC: UITableViewController {
    
    @IBOutlet var agendaTBC: UITableView!
    lazy var note = Note()
    
    let today = Date.now
    var formatter1 = DateFormatter()
    
    var isLast: Bool = false
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    // MARK: - tableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "agenda", for: indexPath)
        
        if #available(iOS 16.0, *) {
            cell.contentConfiguration = UIHostingConfiguration {
                HStack(alignment: .center) {
                        
                        // end of VStack
                    VStack(alignment: .center, spacing: 0) {
                        Circle().fill(.blue).frame(width: 25, height: 25)
                        if !isLast {
                            Rectangle().fill(Color.blue).frame(width: 3, height: 20, alignment: .center)//.padding(.leading, 15.5)
                        }
                    }
                    Text("Задача")
                    Spacer()
//                        VStack {
//                            Spacer()
//                            Spacer()
//                            Text(formatter1.string(from: today))
//
//                            Text("1\(0+indexPath.row):00")
//                                .font(.system(.caption))
//                                .foregroundColor(.gray)
//                                .fontWeight(.black)
//                        }
                        Image(systemName: "chevron.right")
                    }
                    // end of HStack
            }
        } else {
            fatalError("Need an iOS 16.0 or newer")
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // note.agendaItems
    }
    
    
    
    
    // MARK: - Functions
    
    //TODO: Add deletion on swipe, adding func
    
    
    // MARK: - Data Save functions
    
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

    
}

