//
//  TimeAgendaView.swift
//  BlockNote app
//
//  Created by user on 28.07.2023.
//

import SwiftUI

struct TimeAgendaView: View {
    
    let group = GroupType()
    
    var body: some View {
        NavigationStack {
            List(group.itemsOfAgendaArray) { agenda in
                AgendaView(isLast: false)
            }
        }
    }
}

struct TimeAgendaView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        TimeAgendaView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
