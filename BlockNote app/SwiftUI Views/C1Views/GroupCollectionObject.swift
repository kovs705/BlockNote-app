//
//  GroupCollectionObject.swift
//  BlockNote app
//
//  Created by Kovs on 20.12.2021.
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
                if groupType.noteTypes?.count ?? 0 <= 1 {
                    HStack {
                        Text("1 note")
                        Spacer()
                    }
                } else {
                    HStack {
                        Text("\(groupType.noteTypes!.count) notes")
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
func returnUIColorFromString(string: String) -> UIColor {
    return UIColor(named: string) ?? UIColor(named: "GreenAvocado")!
}
