//
//  TimeAgendaVM.swift
//  BlockNote app
//
//  Created by user on 27.07.2023.
//

import SwiftUI
import CoreData

enum TimeAgendaIntent {
    // intents
    case test
}

class TimeAgendaViewModel: ObservableObject {
    
    var persistenceController: PersistenceController
    var group: GroupType
    
    init(persC: PersistenceController = PersistenceController(), group: GroupType) {
        self.persistenceController = persC
        self.group = group
    }
    
    func reduce(intent: TimeAgendaIntent) {
        switch intent {
        case .test:
            print("Test")
            break
        }
    }
    
    
}
