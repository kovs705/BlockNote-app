//
//  C2GroupView.swift
//  BlockNote app
//
//  Created by Kovs on 12.08.2023.
//

import SwiftUI

struct C2GroupView: View {
    
    @StateObject var viewModel: C2GroupViewModel
    @State var group: GroupType
    @State var presentSheet = false
    
    var body: some View {
        Form {
            Section {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundColor(.greenAvocado)
                    VStack {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white).opacity(0.5)
                                    .frame(width: 35, height: 35)
                                Text(group.wrappedEmoji)
                            }
                            .padding(13)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(group.wrappedGroupName)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 17, weight: .bold))
                                    .padding(.leading, 13)
                                    .padding(.trailing, 5)
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
                }
                .frame(width: 165, height: 165)
            }
            
            Section {
                TextField("Group name", text: $group.groupName) // make checking for group name using Combine
                Button {
                    presentSheet.toggle()
                } label: {
                    HStack {
                        Text("Change icon")
                        Spacer()
                        Text(group.wrappedEmoji)
                    }
                }
                
            }
            
            Button {
                // save changes
            } label: {
                Text("Save changes")
            }
            
            Color.blueBerry
                .frame(width: 200, height: 2400)
            
        }
        .navigationTitle("Edit")
        .sheet(isPresented: $presentSheet, content: {
            EmojiPicker()
                .presentationDetents([.height(250)])
//                .scrollContentBackground(.hidden)
        })
    }
    
    func setNumber(_ group: GroupType) -> String {
        if group.number == 0 {
            return "0 notes"
        } else if group.number == 1 {
            return "1 note"
        } else {
            return "\(group.number) notes"
        }
    }
}

struct C2GroupView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        C2GroupView(viewModel: C2GroupViewModel(), group: GroupType.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
