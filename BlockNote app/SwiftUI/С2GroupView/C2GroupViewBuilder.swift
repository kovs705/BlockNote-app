//
//  C2GroupViewBuilder.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 10.09.2023.
//

import SwiftUI

class C2GroupViewBuilder {

    func setNumber(_ group: GroupType) -> String {
        if group.number == 0 {
            return "0 notes"
        } else if group.number == 1 {
            return "1 note"
        } else {
           return  "\(group.number) notes"
        }
    }

    @ViewBuilder func placeGroupNameAndNumber(name: Binding<String>, group: GroupType) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name.wrappedValue)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.leading, 13)
                    .padding(.trailing, 5)
                    .lineLimit(3)
                Text(setNumber(group))
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 17, weight: .regular))
                    .padding(.leading, 13)
                    .padding(.trailing, 5)
                    .padding(.bottom, 13)
            }
            Spacer()
        }

    }

    @ViewBuilder func placeGroupEmoji(_ emoji: String) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white).opacity(0.5)
                    .frame(width: 35, height: 35)
                Text(emoji)
            }
            .padding(13)

            Spacer()
        }
    }
}
