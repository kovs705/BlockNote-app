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
    
    @State var groupName: String
    @State var groupColor: String
    @State var groupEmoji: String
    
    var body: some View {
        Form {
            Section {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundColor(Color(groupColor))
                    VStack {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white).opacity(0.5)
                                    .frame(width: 35, height: 35)
                                Text(groupEmoji)
                            }
                            .padding(13)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text($groupName.wrappedValue)
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
                }
                .frame(width: 165, height: 165)
            }
            
            Section {
                TextField("Group name", text: $groupName) // make checking for group name using Combine
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
            
        }
        
        .navigationTitle("Edit")
        .blurredSheet(.init(.regularMaterial), show: $presentSheet) {
        } content: {
            EmojiPicker(action: { emoji in
                groupEmoji = emoji
            })
                .presentationDetents([.height(250)])
        }
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
        C2GroupView(viewModel: C2GroupViewModel(), group: GroupType.example, groupName: "Test words", groupColor: "GreenAvocado", groupEmoji: "😍")
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
