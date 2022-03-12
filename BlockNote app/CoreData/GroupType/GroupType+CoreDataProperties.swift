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

    @NSManaged public var groupName: String?
    @NSManaged public var groupColor: String?
    @NSManaged public var noteTypes: NSSet?
    
    public var wrappedNumber: Int {
        number
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

extension GroupType : Identifiable {

}




//import Foundation
//import CoreData


//extension Note {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
//        return NSFetchRequest<Note>(entityName: "Note")
//    }
//
//    @NSManaged public var noteName: String?
//    @NSManaged public var noteLevel: String?
//    @NSManaged public var noteType: String?
//    @NSManaged public var noteItems: NSSet?
//    @NSManaged public var noteIsMarked: Bool
//    
//    @NSManaged public var typeOfNote: GroupType?
//
//    public var wrappedNoteType: String {
//        noteType ?? "Unknown wrapped group"
//    }
//    
//    public var wrappedNoteName: String {
//        noteName ?? "Unknown wrapped NOTE name"
//    }
//    
//    public var noteItemArray: [NoteItem] {
//        let set = noteItems as? Set<NoteItem> ?? []
//        return set.sorted {
//            $0.wrappedNoteItemName < $1.wrappedNoteItemName
//        }
//    }
//    
//}



