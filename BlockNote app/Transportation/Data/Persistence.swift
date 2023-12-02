//
//  Persistence.swift
//  BlockNote
//
//  Created by Kovs on 06.09.2021.
//

import SwiftUI
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    @Environment(\.managedObjectContext) var viewContext
    let cachePhoto = NSCache<NSString, NSData>()
    let cacheString = NSCache<NSString, NSString>()

    static var preview: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.viewContext

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            return true
        }

        do {
            try viewContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        return result
    }()

//    func ultimateSave(for entity: String, blockType: BlockCases, in object: NSManagedObject, blockText: String?, usingArray: [NSManagedObject], tableView: UITableView) {
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        let managedContext = appDelegate.persistentContainerOffline.viewContext
//
//        guard let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext) else { return }
//
//        switch blockType {
//           case .title:
//            C1NoteDetailExt().save(blockType: <#T##String#>, blockText: <#T##String#>, noteListTB: <#T##UITableView#>)
//            C1NoteDetailExt().sortAndUpdate()
//
//                // case .text:
//
//        case .space:
//            <#code#>
//        case .photo:
//            <#code#>
//        }
//
//    }

//    let container: NSPersistentCloudKitContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentCloudKitContainer(name: "BlockNote_app")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//    }

    lazy var persistentContainerOffline: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BlockNote_app")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
