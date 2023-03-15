//
//  Noteitem+CoreDataProperties.swift
//  BlockNote app
//
//  Created by Kovs on 14.11.2021.
//
//

import Foundation
import CoreData


extension NoteItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteItem> {
        return NSFetchRequest<NoteItem>(entityName: "NoteItem")
    }
    
    @NSManaged var noteItemOrder: Int
    
    @NSManaged public var noteItemType: String?
    @NSManaged public var noteItemName: String?
    @NSManaged public var lastChangedNI: Date?
    
    @NSManaged public var noteItemPhoto: Data?
    
    @NSManaged public var noteItemText: String
    @NSManaged public var note: Note?
    
    public var wrappedNoteItemName: String {
        noteItemName ?? "Unknown NoteItem name"
    }
//    public var wrappedNoteItemText: String {
//        noteItemText ?? "Unknown text"
//    }
    public var wrappedNoteItemOrder: Int {
        noteItemOrder
    }
}

extension NoteItem : Identifiable {

}
