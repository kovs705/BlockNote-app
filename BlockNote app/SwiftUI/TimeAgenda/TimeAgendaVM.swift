//
//  TimeAgendaVM.swift
//  BlockNote app
//
//  Created by user on 27.07.2023.
//

import SwiftUI

enum TimeAgendaIntent {
    // intents
    case test
}

class TimeAgendaViewModel: ObservableObject {
    
    var persistenceController: PersistenceController
    
    init(persC: PersistenceController = PersistenceController()) {
        self.persistenceController = persC
    }
    
    func reduce(intent: TimeAgendaIntent) {
        switch intent {
        case .test:
            print("Test")
            break
        }
    }
    
    
}
