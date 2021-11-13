//
//  Noteitem+CoreDataProperties.swift
//  BlockNote app
//
//  Created by Kovs on 14.11.2021.
//
//

import Foundation
import CoreData


extension Noteitem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Noteitem> {
        return NSFetchRequest<Noteitem>(entityName: "Noteitem")
    }

    @NSManaged public var itemType: String?
    @NSManaged public var noteItemName: String?
    
    @NSManaged public var noteItemText: String?
    @NSManaged public var note: Note?
    
    public var wrappedNoteItemName: String {
        noteItemName ?? "Unknown NoteItem name"
    }
    public var wrappedNoteItemText: String {
        noteItemText ?? "Unknown text"
    }
    public var wrappedNoteItemOrder: Int {
        noteItemOrder
    }
}

extension Noteitem : Identifiable {

}
