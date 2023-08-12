//
//  С2GroupVM.swift
//  BlockNote app
//
//  Created by Kovs on 12.08.2023.
//

import SwiftUI

enum GroupConfigureIntent {
    case test
}

struct GroupConfigureState {
    
}

class C2GroupViewModel: ObservableObject {
    
    @Published var state: GroupConfigureState
    var persistenceC: PersistenceController
    
    init(state: GroupConfigureState = GroupConfigureState(), persistenceC: PersistenceController = PersistenceController()) {
        self.state = state
        self.persistenceC = persistenceC
    }
    
    func reduce(intent: GroupConfigureIntent) {
        switch intent {
        case .test:
            print("Test")
            break
        }
    }
}
