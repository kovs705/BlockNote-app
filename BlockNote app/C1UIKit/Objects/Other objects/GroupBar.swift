//
//  GroupBar.swift
//  BlockNote app
//
//  Created by Kovs on 22.01.2022.
//

import SwiftUI
import CoreData
import UIKit

struct GroupBar: View {
    
    let groupType: GroupType
//    @ObservedObject var viewModel = VM()
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.darkBack
            RoundedRectangle(cornerRadius: 20)
                .fill(returnColorFromString(nameOfColor: groupType.groupColor ?? "GreenAvocado"))
                .cornerRadius(20)
                .frame(width: UIScreen.main.bounds.width - 40, height: 150, alignment: .center)
                .shadow(color: returnColorFromString(nameOfColor: groupType.groupColor ?? "GreenAvocado"), radius: 10, y: 5)
                .brightness(-0.05)
            
            // MARK: - Words and Numbers
            HStack {
                VStack {
                    Spacer()
                    Text("Notes: ")
                        .bold()
                        .font(.system(size: 16))
                        .foregroundColor(Color.textForeground)
                    
                    Spacer()
                    
                    Text("Completed: ")
                        .foregroundColor(Color.textForeground)
                        
                        .bold()
                        .font(.system(size: 16))
                    Spacer()
                } // first column
                .padding()
                
                VStack {
                    Spacer()
                    Text("\(groupType.typesOfNoteArray.count)") // that should work, I guess..
                        .font(.system(size: 16))
                    Spacer()
                    Text("Nothing yet!")
                        .font(.system(size: 14))
                        .padding(.horizontal)
                    Spacer()
                }
                
                Spacer()
                
                // MARK: - Buttons
                VStack {
                    Button(action: {
                    // action to open Tasks of the group:
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(returnColorFromString(nameOfColor: groupType.groupColor ?? "GreenAvocado"))
                                .frame(width: 75, height: 75)
                                .shadow(color: .black.opacity(0.25), radius: 10, y: 5)
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 32))
                                .foregroundColor(Color.textForeground)
                        }
                    }
                    .buttonStyle(AnimatedButton())
                    Button(action: {
                        #warning("Add note function here")
                    }) {
                        // #warning("Think about making buttons standing out of the panel") --> completed
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(returnColorFromString(nameOfColor: groupType.groupColor ?? "GreenAvocado"))
                                // .brightness(-0.1)
                                .frame(width: 75, height: 75)
                                .shadow(color: .black.opacity(0.25), radius: 10, y: 5)
                            Image(systemName: "plus")
                                .font(.system(size: 32))
                                .foregroundColor(Color.textForeground)
                        }
                    }
                    .buttonStyle(AnimatedButton())
                }
                Spacer()
            }
            .padding()
            
        }
        // .frame(width: UIScreen.main.bounds.width - 30, height: 150, alignment: .center)
        .frame(height: 150, alignment: .center)
        .ignoresSafeArea(.all)
        // end of ZStack
    }
    
    func returnColorFromString(nameOfColor: String) -> Color {
        return Color.init(nameOfColor)
    }
    
    func createNoteFunc() {
        // SwiftUI function to create the note in group
        // should reloadData in VC
    }
    
}

struct GroupBar_Previews: PreviewProvider {
    
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let groupType = GroupType(context: moc)
        groupType.groupName = "Test Group name"
        groupType.groupColor = "GreenAvocado"
        
        return NavigationView {
            GroupBar(groupType: groupType)
        }
    }
}
