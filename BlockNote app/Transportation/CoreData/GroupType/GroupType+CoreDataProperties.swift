//
//  GroupType+CoreDataProperties.swift
//  BlockNote app
//
//  Created by Kovs on 22.11.2021.
//
//

import Foundation
import CoreData

extension GroupType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupType> {
        return NSFetchRequest<GroupType>(entityName: "GroupType")
    }
    @NSManaged var number: Int

    @NSManaged public var groupName: String?
    @NSManaged public var groupColor: String?
    
    @NSManaged public var lastChangedGroup: Date?
    @NSManaged public var creationDate: Date?
    @NSManaged public var lastOpened: Date?
    
    @NSManaged public var noteTypes: NSSet?
    @NSManaged public var agendaItems: NSSet?
    @NSManaged public var emoji: String?

    public var wrappedNumber: Int {
        number
    }

    public var wrappedEmoji: String {
        emoji ?? "👨‍💻"
    }

    public var wrappedGroupName: String {
        groupName ?? "Unknown name of the group"
    }

    public var typesOfNoteArray: [Note] {
        let set = noteTypes as? Set<Note> ?? []
        return set.sorted {
            // $0.wrappedNoteName < $1.wrappedNoteName
            $0.noteID < $1.noteID
        }
    }

    public var itemsOfAgendaArray: [Agenda] {
        let set = agendaItems as? Set<Agenda> ?? []
        return set.sorted {
            $0.wrappedAgendaName < $1.wrappedAgendaName
        }
    }

    static var example: GroupType {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let agenda = Agenda(context: viewContext)
        agenda.name = "Test agenda"
        agenda.color = "yellowLemon"
        agenda.dateStart = Date()
        agenda.dateEnd = Date()
        agenda.isDone = false

        let group = GroupType(context: viewContext)
        group.groupName = "Example group"
        group.groupColor = "rosePink"
        group.agendaItems = [agenda, agenda, agenda, agenda, agenda]

        return group
    }
}

// MARK: Generated accessors for noteTypes
extension GroupType {

    @objc(addNoteTypesObject:)
    @NSManaged public func addToNoteTypes(_ value: Note)

    @objc(removeNoteTypesObject:)
    @NSManaged public func removeFromNoteTypes(_ value: Note)

    @objc(addNoteTypes:)
    @NSManaged public func addToNoteTypes(_ values: NSSet)

    @objc(removeNoteTypes:)
    @NSManaged public func removeFromNoteTypes(_ values: NSSet)

}

// adding and deleting
extension NSManagedObject {
    func addObject(value: NSManagedObject, forKey key: String) {
        let notes = self.mutableSetValue(forKey: key)
        notes.add(value)
    }
    func removeObject(value: NSManagedObject, forKey key: String) {
        let notes = self.mutableSetValue(forKey: key)
        notes.remove(value)
    }
}

// MARK: Generated accessors for Note
extension Note {

    @objc(addNoteObject:)
    @NSManaged public func addToNote(_ value: Note)

    @objc(removeNoteObject:)
    @NSManaged public func removeFromNote(_ value: Note)

    @objc(addNote:)
    @NSManaged public func addToNote(_ values: NSSet)

    @objc(removeNote:)
    @NSManaged public func removeFromNote(_ values: NSSet)

}

extension GroupType: Identifiable {

}
