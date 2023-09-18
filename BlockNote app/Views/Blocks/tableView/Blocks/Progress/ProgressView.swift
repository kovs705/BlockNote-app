//
//  ProgressView.swift
//  BlockNote app
//
//  Created by user on 06.09.2023.
//

import SwiftUI

struct ProgressView: View {

    var startDate: Date
    var endDate: Date

    var body: some View {
        HStack {
            CircularView(startDate: startDate, endDate: endDate)

            Spacer()

            Button(action: {
                //
            }, label: {
                ZStack {
                    Circle()
                        .fill(Color(uiColor: .systemBackground).opacity(0.1))
                    Image(systemName: "ellipsis")
                }
            })
        }
        .frame(width: .infinity, height: 150)
    }
}

struct ProgressView_Previews: PreviewProvider {

    static var previews: some View {
        ProgressView(startDate: Date(), endDate: Date())
    }
}
