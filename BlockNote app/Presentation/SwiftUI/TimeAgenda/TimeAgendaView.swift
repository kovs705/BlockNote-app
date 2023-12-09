//
//  TimeAgendaView.swift
//  BlockNote app
//
//  Created by user on 28.07.2023.
//

import SwiftUI

struct TimeAgendaView: View {
    
    @StateObject var viewModel: TimeAgendaViewModel
    
    var body: some View {
        ScrollView {
            Button {
                viewModel.createAgenda()
            } label: {
                Text("Add new agenda")
            }

            LazyVStack {
                ForEach(viewModel.group.itemsOfAgendaArray) { agenda in
                    AgendaView(agenda: agenda, isLast: false)
                }
            }
        }
    }
}

struct TimeAgendaView_Previews: PreviewProvider {

    static var previews: some View {
        TimeAgendaView(viewModel: TimeAgendaViewModel(group: GroupType.example))
    }
}
