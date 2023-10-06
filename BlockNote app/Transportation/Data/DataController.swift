//
//  DataController.swift
//  BlockNote app
//
//  Created by user on 28.07.2023.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "BlockNote_app")

        if inMemory {
            if #available(iOS 16.0, *) {
                container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
            } else {
                container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            }
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    static var preview: DataController = {
       let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()

    func createSampleData() throws {
        let viewContext = container.viewContext

        for i in 1...5 {
            let group = GroupType(context: viewContext)
            group.groupName = "Group \(i)"
            group.groupColor = "blueBerry"
            group.lastChangedGroup = Date()

            for j in 1...5 {
                let agenda = Agenda(context: viewContext)
                agenda.name = "Event \(j)"
                agenda.color = "blueBerry"
                agenda.dateStart = Date()
                agenda.dateEnd = Date()
                agenda.isDone = true
                agenda.desc = "A description of event "
            }
        }

        try viewContext.save()
    }

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = GroupType.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Agenda.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)

    }

}
