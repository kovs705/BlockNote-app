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

struct TimeAgendaState {
    // states
}

class TimeAgendaViewModel: ObservableObject {
    
    @Published var state: TimeAgendaState
    var persistenceController: PersistenceController
    
    init(state: TimeAgendaState = TimeAgendaState(), persC: PersistenceController = PersistenceController()) {
        self.state = state
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
