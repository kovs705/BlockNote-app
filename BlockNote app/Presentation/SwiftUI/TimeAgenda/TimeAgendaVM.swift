//
//  TimeAgendaVM.swift
//  BlockNote app
//
//  Created by user on 27.07.2023.
//

import SwiftUI
import CoreData

enum TimeAgendaIntent {
    // intents
    case test
}

class TimeAgendaViewModel: ObservableObject {

    var persistenceController: PersistenceController
    var group: GroupType
    
    var managedContext: NSManagedObjectContext

    init(persC: PersistenceController = PersistenceController(), group: GroupType) {
        self.persistenceController = persC
        self.group = group
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.managedContext = appDelegate.persistentContainerOffline.viewContext
        } else {
            self.managedContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        }
        
        
    }

    func createAgenda() {
        guard let entity = NSEntityDescription.entity(forEntityName: "Agenda", in: managedContext) else { return }
        let agenda = NSManagedObject(entity: entity, insertInto: managedContext)
        
        agenda.setValue(Date(), forKey: "creationDate")
        agenda.setValue("This is not a description", forKey: "desc")
        
        agenda.setValue(false, forKey: "isDone")
        
        agenda.setValue("This is a name", forKey: "name")
        
        do {
            group.addObject(value: agenda, forKey: "agendaItems")
            
            if group.hasChanges {
                try managedContext.save()
            } else {
                print("Something wrong on saving agenda.")
            }
        } catch let error as NSError {
            print("Could not save and add note. \(error), \(error.userInfo)")
        }
    }

}
