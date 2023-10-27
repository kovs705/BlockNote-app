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
        List(viewModel.group.itemsOfAgendaArray) { agenda in
            NavigationLink {
                DictView()
            } label: {
                AgendaView(agenda: agenda, isLast: false)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Agenda")
    }
}

struct TimeAgendaView_Previews: PreviewProvider {

    static var previews: some View {
        TimeAgendaView(viewModel: TimeAgendaViewModel(group: GroupType.example))
    }
}
