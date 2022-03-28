//
//  ObjectColorStruct.swift
//  BlockNote
//
//  Created by Kovs on 22.09.2021.
//

import SwiftUI
import CoreData

struct GridObject: View {
    let groupType: GroupType
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(returnColorFromString(nameOfColor: groupType.groupColor ?? "YellowLemon"))
                .frame(width: 175, height: 175)
            VStack {
                Spacer()
                HStack {
                    // name of the group:
                    Text(groupType.groupName ?? "Test name")
                        .bold()
                        .lineLimit(2)
                    Spacer()
                }
                // number of notes inside:
                if groupType.noteTypes?.count == 1 {
                    HStack {
                        Text("1 note")
                        Spacer()
                    }
                } else {
                    HStack {
                        Text("\(groupType.typesOfNoteArray.count) notes")
                        Spacer()
                    }
                }
            }
            .padding()
            // end of VStack
        }
        // end of ZStack
        .frame(width: 170, height: 170)
    }
}

func returnColorFromString(nameOfColor: String) -> Color {
    return Color.init(nameOfColor)
}

