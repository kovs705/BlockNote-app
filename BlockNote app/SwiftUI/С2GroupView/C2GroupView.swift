//
//  C2GroupView.swift
//  BlockNote app
//
//  Created by Kovs on 12.08.2023.
//

import SwiftUI

struct C2GroupView: View {

    @StateObject var c2groupViewModel: C2GroupViewModel
    var viewBuilder = C2GroupViewBuilder()

    var body: some View {
        Form {
            Section {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundColor(Color(c2groupViewModel.groupColor))
                    VStack {
                        viewBuilder.placeGroupEmoji(c2groupViewModel.groupEmoji)

                        Spacer()

                        viewBuilder.placeGroupNameAndNumber(name: $c2groupViewModel.groupName, group: c2groupViewModel.group)
                    }
                }
                .frame(width: 165, height: 165)
            }

            Section {
                TextField("Group name", text: $c2groupViewModel.groupName) // make checking for group name using Combine
                Button {
                    c2groupViewModel.reduce(intent: .presentSheet)
                } label: {
                    HStack {
                        Text("Change icon")
                        Spacer()
                        Text(c2groupViewModel.groupEmoji)
                    }
                }

            }

            Button {
                // save changes
                c2groupViewModel.reduce(intent: .saveChanges)
            } label: {
                Text("Save changes")
            }

        }

        .navigationTitle("Edit")
        .blurredSheet(.init(.regularMaterial), show: $c2groupViewModel.presentSheet) {
        } content: {
            EmojiPicker(action: { emoji in
                c2groupViewModel.reduce(intent: .updateEmoji(emoji: emoji))
            })
                .presentationDetents([.height(250)])
        }
    }

}

struct C2GroupView_Previews: PreviewProvider {

    static var dataController = DataController.preview
    static var testGroup = GroupType.example

    static var previews: some View {
        C2GroupView(c2groupViewModel: C2GroupViewModel(group: testGroup, groupName: "Test", groupColor: "greenAvocado", groupEmoji: "😍"))
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
