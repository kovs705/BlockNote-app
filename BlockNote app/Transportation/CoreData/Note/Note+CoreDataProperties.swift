//
//  Note+CoreDataProperties.swift
//  BlockNote app
//
//  Created by Kovs on 12.12.2021.
//
//

import Foundation
import CoreData

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
    @NSManaged var noteID: Int

    @NSManaged public var noteName: String?
    @NSManaged public var noteLevel: String?
    @NSManaged public var noteType: String?
    
    @NSManaged public var lastChangedNote: Date?
    @NSManaged public var creationDate: Date?
    
    @NSManaged public var noteItems: NSSet?
    @NSManaged public var noteIsMarked: Bool

    @NSManaged public var typeOfNote: GroupType?

    public var wrappedNoteType: String {
        noteType ?? "Unknown wrapped group"
    }

    public var wrappedNoteName: String {
        noteName ?? "Unknown wrapped NOTE name"
    }

    public var noteItemArray: [NoteItem] {
        let set = noteItems as? Set<NoteItem> ?? []
        return set.sorted {
            $0.wrappedNoteItemName < $1.wrappedNoteItemName
        }
    }

}

// MARK: Generated accessors for noteItems
extension Note {

    @objc(addNoteItemsObject:)
    @NSManaged public func addToNoteItems(_ value: NoteItem)

    @objc(removeNoteItemsObject:)
    @NSManaged public func removeFromNoteItems(_ value: NoteItem)

    @objc(addNoteItems:)
    @NSManaged public func addToNoteItems(_ values: NSSet)

    @objc(removeNoteItems:)
    @NSManaged public func removeFromNoteItems(_ values: NSSet)

}

extension Note: Identifiable {

}
