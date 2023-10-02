//
//  AgendaView.swift
//  BlockNote app
//
//  Created by Kovs on 18.12.2022.
//

import SwiftUI
import CoreData

struct AgendaView: View {

    let agenda: Agenda

    let today = Date.now
    var formatter1 = DateFormatter()

    var isLast: Bool

    var body: some View {

            HStack {
                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: 35, height: 35)
                    if !isLast {
                        Capsule()
                            .fill(Color.blue)
                            .frame(width: 15, height: 35, alignment: .center)
                            .offset(y: 20)
                    }
                }
                .padding(.horizontal)

                VStack {
                    Text(agenda.wrappedAgendaName)
                        .font(.title3)

                    Text(showTime())
                        .font(.system(.caption))
                        .foregroundColor(.gray)
                        .fontWeight(.black)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .padding(.horizontal)
            }

    }

    func showTime() -> String {
        formatter1.dateFormat = "DD.mm"
        return formatter1.string(from: today)
    }
}

struct AgendaView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaView(agenda: GroupType.example.itemsOfAgendaArray.first!, isLast: false)
    }
}
