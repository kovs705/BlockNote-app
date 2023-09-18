//
//  PersistenceBlockController.swift
//  BlockNote app
//
//  Created by Kovs on 08.04.2023.
//

import UIKit
import CoreData

class PersistenceBlockController {

    func delegateSave() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainerOffline.viewContext

        do {
            if managedContext.hasChanges {
                try managedContext.save()
            } else {
                print("Wrong on updating the note item")
            }
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }

    // MARK: - update block
    func update(blockText: String, block: NoteItem?, noteListTB: UITableView) {

/// update the date of the last changing
        block?.setValue(Date(), forKey: Keys.niLastChanged)
/// update the text of the block
        block?.setValue(blockText, forKey: Keys.niText)

        delegateSave()
    }

    func setValues(for block: NSManagedObject, from type: BlockCases, pickedImage: UIImage?) {
        switch type {
        case .title:
            block.setValue(Block.titleBlock, forKey: Keys.niType)
            block.setValue(Block.titleToSave, forKey: Keys.niText)
        case .text:
            block.setValue(Block.textBlock, forKey: Keys.niType)
            block.setValue(Block.blockToSave, forKey: Keys.niText)
        case .photo:
            block.setValue(Block.photoBlock, forKey: Keys.niType)
            block.setValue(pickedImage?.toData as NSData?, forKey: Keys.niPhoto)
        case .space:
            block.setValue(Block.spaceBlock, forKey: Keys.niType)
        }

    }

}
