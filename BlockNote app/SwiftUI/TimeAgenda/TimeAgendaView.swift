//
//  TimeAgendaView.swift
//  BlockNote app
//
//  Created by user on 28.07.2023.
//

import SwiftUI

struct TimeAgendaView: View {
    
    @StateObject var viewModel: TimeAgendaViewModel
    let group: GroupType
    
    var body: some View {
        NavigationStack {
            List(group.itemsOfAgendaArray) { agenda in
                Text("Hello")
            }
            .navigationTitle("Agenda")
        }
    }
}

struct TimeAgendaView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        TimeAgendaView(viewModel: TimeAgendaViewModel(), group: GroupType.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
