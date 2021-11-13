//
//  groupCreate.swift
//  BlockNote
//
//  Created by Kovs on 24.10.2021.
//

import SwiftUI
import Combine
import CoreData

// MARK: - instructions
    /// create a colorPicker for GridObject
    /// create a preview of GridObject with the name, color, number of notes and other things (like type, or lvl)
    /// put picker buttons in view
    ///
    ///
//

struct groupCreateView: View {
    
    @Binding var chosenColor: Color
    @Binding var nameOfGroup: String
    
    @FetchRequest(entity: GroupType.entity(), sortDescriptors: [NSSortDescriptor(key: "groupName", ascending: true)]) var types: FetchedResults<GroupType>
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isEditing = false // textFields checker
    
    @State private var groupColor: Color = .greenAvocado // colorPicker base color
    @State private var isDragging: Bool = false // colorPicker gesture
    @State private var isSelected: Bool = false
    
//    init(chosenColor: Binding<Color>) {
//        self._chosenColor = chosenColor
//    }
    
    let colorToPick: [Color] = [.blueBerry, .brownSugar, .greenAvocado, .greyCloud, .purpleBlackBerry, .redStrawBerry, .rosePink, .yellowLemon]
    
    var body: some View {
        ZStack {
            Color.darkBack // background
            
            VStack(alignment: .center) {
                Text("Create a group..")
                    .padding()
                    .font(.footnote)
                
                VStack {
                    // empty space
                }
                .frame(height: 40)
                
                // MARK: - Preview
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(groupColor)
                        .frame(width: 175, height: 175)
                    VStack {
                        Spacer()
                        if nameOfGroup == "" {
                            HStack {
                                // name of the group:
                                Text("Test name")
                                    .bold()
                                    .lineLimit(2)
                                Spacer()
                            }
                        } else {
                            HStack {
                                // name of the group:
                                Text("\(nameOfGroup)")
                                    .bold()
                                    .lineLimit(2)
                                Spacer()
                            }
                        }
                        
                        // number of notes inside:
                        HStack {
                            Text("15 notes")
                            Spacer()
                        }
                    }
                    .padding()
                    // end of VStack
                }
                // end of ZStack
                .frame(width: 170, height: 170)
                .padding()
                
                
                // MARK: - ColorPicker
                
                HStack(alignment: .center, spacing: 5) {
                    ForEach(colorToPick, id: \.self) { color in
                        
                        Button(action: {
                            // give the color to the binding
                        }) {
                            ZStack {
                                color
                                    .animation(.spring())
                                    .frame(width: isSelected ? 40 : 25, height: isSelected ? 40 : 25)
                                    .cornerRadius(isSelected ? 12.5 : 20)
                                    .shadow(radius: 8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12.5).stroke(isSelected ? Color.clear : Color.white, lineWidth: 2.0)
                                    )
                            }
                        }
                        .gesture(
                            DragGesture().onChanged({ (value) in
                                self.isSelected = true
                                
                                // move others?
                            })
                                .onEnded({ (_) in
                                    self.isSelected = false
                                    
                                })
                        )
                        
                    }
                }
                // make them scalable on tap
                // vertical picker?
                .frame(height: 40)
                
                // MARK: - TextField
                TextField("Name of a group..", text: $nameOfGroup) { isEditing in
                    self.isEditing = isEditing
                } onCommit: {
                    UIApplication.shared.endEditing()
                    // create group:
                    // addNewGroup(nameOfGroup: nameOfGroup)
                }
                .frame(height: 55)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 4)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(isEditing ? Color.textForeground : Color.gray))
                .padding([.horizontal], 24)
                .padding() // 18 - limit of characters
                .foregroundColor(Color.textForeground)
                .lineLimit(1)
                .font(.system(size: 18))
                
                // MARK: - Create group button
                Button(action: {
                    addNewGroup(nameOfGroup: nameOfGroup)
                }, label: {
                    Text("Add group!")
                })
                // end of the button
                
                Spacer()
                Spacer()
                Spacer()
            }
            // main VStack
        }
        // ZStack
        .ignoresSafeArea(.all)
    }
    // body
    
    // MARK: - Add new group func
    func addNewGroup(nameOfGroup: String) {
            let newGroup = GroupType(context: viewContext)
            
            for type in types { // for each group in CoreData:
                if nameOfGroup == type.groupName { // if the name is equal as an existing name
                    newGroup.groupName = "THE SAME GROUP"
                } else if nameOfGroup == "" { // or this name is empty
                    newGroup.groupName = "Unknown group"
                } else {
                    newGroup.groupName = nameOfGroup
                }
            }
//
//            if nameOfGroup == "" {
//                newGroup.groupName = "Unknown group"
//            } else {
//                newGroup.groupName = nameOfGroup
//            }
            
            newGroup.number = (types.last?.number ?? 0) + 1
            newGroup.noteTypes = [] // for future notes?
            
            // MARK: - function for colorPicker
            newGroup.groupColor = "RedStrawBerry"
            
            do {
                try self.viewContext.save()
                print("Group is added!")
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
    }
}

// MARK: - Color picker


func returnColorFromStringForPreview(nameOfColor: String) -> Color {
    if nameOfColor == "" {
        let nameOfColor = "GreenAvocado"
        return Color.init(nameOfColor)
    } else {
        return Color.init(nameOfColor)
    }
}


//
//struct groupCreate_Previews: PreviewProvider {
//
//    var nameOfGroup: String = "Test Name"
//    let chosenColor: Color = .greenAvocado
//
//    static var previews: some View {
//        groupCreateView(chosenColor: chosenColor, nameOfGroup: nameOfGroup)
//    }
//}
//
