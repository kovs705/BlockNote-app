//
//  C2GroupView.swift
//  BlockNote app
//
//  Created by Kovs on 12.08.2023.
//

import SwiftUI

struct C2GroupView: View {
    
    @StateObject var viewModel: C2GroupViewModel
    let group: GroupType
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.greenAvocado)
                    VStack {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white).opacity(0.5)
                                Text(group.wrappedEmoji)
                            }
                            .padding(13)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Text(group.wrappedGroupName)
                            .padding(.leading, 13)
                            .padding(.trailing, 5)
                            
                        // Text(group.number)
                        // number of notes
                        Text(setNumber(group))
                    }
                }
                .frame(width: 165, height: 165)
            }
            .navigationTitle("Edit")
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
        C2GroupView(viewModel: C2GroupViewModel(), group: GroupType.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
