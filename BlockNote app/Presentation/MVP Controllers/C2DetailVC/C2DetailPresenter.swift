//
//  C2DetailPresenter.swift
//  BlockNote app
//
//  Created by Kovs on 08.07.2023.
//

import UIKit
import CoreData

protocol C2DetailViewProtocol: AnyObject {
    var delegate: detail_vc_Delegate? { get set }
    func popVC()
    func presentAlert(_ alert: UIAlertController, animated: Bool)
    func performBatchUpdates()

    func performTransition(to vc: UIViewController)
}

protocol C2DetailPresenterProtocol: AnyObject {
    var groupType: GroupType { get set }

    var noteArraySorted: [Note] { get set }

    init(view: C2DetailViewProtocol, groupType: GroupType)

    func addNote()
    func acceptAttention()
    func sortArray()
    func deleteGroup(groupName: String)

    var managedContext: NSManagedObjectContext { get }
    func performTransitionToAgendaVC(groupType: GroupType)
}

final class C2DetailPresenter: C2DetailPresenterProtocol {

    var groupType: GroupType
    var noteArraySorted: [Note] = [Note]()

    weak var view: C2DetailViewProtocol?

    var managedContext: NSManagedObjectContext

    required init(view: C2DetailViewProtocol, groupType: GroupType) {
        self.view = view
        self.groupType = groupType

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.managedContext = appDelegate.persistentContainerOffline.viewContext
        } else {
            self.managedContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        }
    }

    func sortArray() {
        noteArraySorted = groupType.typesOfNoteArray.sorted {
            $0.noteID < $1.noteID
        }
    }

    // MARK: - Delete group
    func deleteGroup(groupName: String) {

        if groupType.wrappedGroupName == groupName {

            if !self.groupType.typesOfNoteArray.isEmpty {

                for note in self.groupType.typesOfNoteArray {
                    managedContext.delete(note)
                }
            } else {
                print("No notes in array")
            }

            managedContext.delete(self.groupType)

            do {
                try managedContext.save()
                self.view?.popVC()
                self.view?.delegate?.closeAndDelete()
            } catch {
                print("Something went wrong while deleting the group and note!!")
            }
        } else {
            print("Something wrong on checking the name of the group!")
        }
    }

    // MARK: - Add note
    @objc func addNote() {
        let alert = UIAlertController(title: "New Note", message: "Enter a name for the note", preferredStyle: .alert)

        // save button
        let saveNoteButton = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else { return }

            guard
                let textField = alert.textFields?.first,
                let noteToSave = textField.text
            else {
                print("Note has not been saved")
                return
            }
            // save action:
            self.saveNote(noteName: noteToSave) // -----------> Check this

        }
        // cancel button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addTextField()
        alert.addAction(saveNoteButton)
        alert.addAction(cancelButton)

        self.view?.presentAlert(alert, animated: true)
    }

    // MARK: - accept attention and repeat
    func acceptAttention() {
        let attentionAlert = UIAlertController(title: "Enter note name", message: "Type something in field", preferredStyle: .alert)

        let acceptButton = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.addNote()
        }

        attentionAlert.addAction(acceptButton)
        self.view?.presentAlert(attentionAlert, animated: true)
    }

    // MARK: - Save the note to the group from the Adding alert
    func saveNote(noteName: String) {

        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext) else { return }
        let note = NSManagedObject(entity: entity, insertInto: managedContext)

        if groupType.wrappedGroupName == "" {
            note.setValue("Unknown group", forKey: Keys.nType)
        } else {
            note.setValue(self.groupType.wrappedGroupName, forKey: Keys.nType)
        }

        if groupType.typesOfNoteArray.isEmpty {
            note.setValue(1, forKey: Keys.nID)
        } else {
            note.setValue((groupType.typesOfNoteArray.last?.noteID ?? 0) + 1, forKey: Keys.nID)
            print("\((groupType.typesOfNoteArray.count) + 1) note added already")
        }

        note.setValue("Test level", forKey: Keys.nLevel)
        note.setValue(Date(), forKey: Keys.nCreationDate)

        if noteName.isEmpty {
            acceptAttention()
            return
        } else {
            note.setValue(noteName, forKey: Keys.nName)
        }
        // Append the note to the group:
        do {
            // adding object
            self.groupType.addObject(value: note, forKey: Keys.noteTypes)
            // saving changes

            if self.groupType.hasChanges {
                sortArray()
                self.view?.performBatchUpdates()
                try managedContext.save()
            } else {
                print("Something wrong on saving note. No changes? No bitches?")
            }

        } catch let error as NSError {
            print("Could not save and add note. \(error), \(error.userInfo)")
        }

        //        noteName  noteLevel   noteType    noteItems   noteIsMarked
        //        typeOfNote    wrappedNoteType     wrappedNoteName     noteItemArray
    }

    func performTransitionToAgendaVC(groupType: GroupType) {
        let coordinator = Builder()
        let agendaVC = coordinator.getAgendaVC(group: groupType)

        self.view?.performTransition(to: agendaVC)
    }

}
