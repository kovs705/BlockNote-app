//
//  Agenda+CoreDataProperties.swift
//  
//
//  Created by Kovs on 18.12.2022.
//
//

import Foundation
import CoreData


extension Agenda {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Agenda> {
        return NSFetchRequest<Agenda>(entityName: "Agenda")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    
    @NSManaged public var dateStart: Date?
    @NSManaged public var dateEnd: Date?
    
    @NSManaged public var color: String?
    
    @NSManaged public var isImportant: Bool
    @NSManaged public var isDone: Bool
    
    @NSManaged public var note: Note?

}

extension Agenda : Identifiable {
    
}
