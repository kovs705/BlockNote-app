//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Kovs on 23.03.2023.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoData: Data?
    @NSManaged public var number: Int16
    @NSManaged public var noteItem: NoteItem?

}
