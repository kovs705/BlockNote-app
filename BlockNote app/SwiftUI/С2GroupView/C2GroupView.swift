//
//  C2GroupView.swift
//  BlockNote app
//
//  Created by Kovs on 12.08.2023.
//

import SwiftUI

struct C2GroupView: View {
    
    @StateObject var vm: C2GroupViewModel
    var viewBuilder = C2GroupViewBuilder()
    
    var body: some View {
        Form {
            Section {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundColor(Color(vm.groupColor))
                    VStack {
                        viewBuilder.placeGroupEmoji(vm.groupEmoji)
                        
                        Spacer()
                        
                        viewBuilder.placeGroupNameAndNumber(name: $vm.groupName, group: vm.group)
                    }
                }
                .frame(width: 165, height: 165)
            }
            
            Section {
                TextField("Group name", text: $vm.groupName) // make checking for group name using Combine
                Button {
                    vm.reduce(intent: .presentSheet)
                } label: {
                    HStack {
                        Text("Change icon")
                        Spacer()
                        Text(vm.groupEmoji)
                    }
                }
                
            }
            
            Button {
                // save changes
                vm.reduce(intent: .saveChanges)
            } label: {
                Text("Save changes")
            }
            
        }
        
        .navigationTitle("Edit")
        .blurredSheet(.init(.regularMaterial), show: $vm.presentSheet) {
        } content: {
            EmojiPicker(action: { emoji in
                vm.reduce(intent: .updateEmoji(emoji: emoji))
            })
                .presentationDetents([.height(250)])
        }
    }
    
}

struct C2GroupView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    static var testGroup = GroupType.example
    
    static var previews: some View {
        C2GroupView(vm: C2GroupViewModel(group: testGroup, groupName: "Test", groupColor: "GreenAvocado", groupEmoji: "😍"))
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
