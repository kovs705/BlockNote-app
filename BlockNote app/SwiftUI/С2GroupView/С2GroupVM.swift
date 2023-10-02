//
//  С2GroupVM.swift
//  BlockNote app
//
//  Created by Kovs on 12.08.2023.
//

import SwiftUI
import CoreData

class C2GroupViewModel: ObservableObject {

    @Published var group: GroupType
    @Published var presentSheet = false

    @Published var groupName: String
    @Published var groupColor: String
    @Published var groupEmoji: String

    var persistenceC = PersistenceController()

    init(group: GroupType, presentSheet: Bool = false, groupName: String, groupColor: String, groupEmoji: String, persistenceC: PersistenceController = PersistenceController()) {
        self.group = group
        self.presentSheet = presentSheet
        self.groupName = groupName
        self.groupColor = groupColor
        self.groupEmoji = groupEmoji
        self.persistenceC = persistenceC
    }

    func reduce(intent: GroupConfigureIntent) {
        switch intent {
        case .test:
            print("Test")
        case .saveChanges:
            saveChanges()
        case .presentSheet:
            presentSheet.toggle()
        case .updateEmoji(let emoji):
            groupEmoji = emoji
        }
    }

    func saveChanges() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainerOffline.viewContext

        group.emoji = groupEmoji
        group.groupName = groupName
        group.groupColor = groupColor
        group.lastChangedGroup = Date()

        do {
            try managedContext.save()
        } catch {
            print("Something wrong on updating the group")
        }
    }
}

enum GroupConfigureIntent {
    case test
    case saveChanges
    case presentSheet
    case updateEmoji(emoji: String)
}
