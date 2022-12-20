//
//  AgendaView.swift
//  BlockNote app
//
//  Created by Kovs on 18.12.2022.
//

import SwiftUI
import CoreData

struct AgendaView: View {
    
    let agenda = Note()
    
    let today = Date.now
    var formatter1 = DateFormatter()
    
    
    
    var isLast: Bool
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
            HStack {
                VStack {
                    Spacer()
                    Text(formatter1.string(from: today))
                        .font(.system(.caption))
                        .foregroundColor(.gray)
                        .fontWeight(.black)
                }
                // end of VStack
                
                Circle().fill(.blue).frame(width: 25, height: 25)
                Text("Задача")
                Spacer()
                Image(systemName: "chevron.right")
            }
            // end of HStack
            
            if !isLast {
                Rectangle().fill(Color.blue).frame(width: 1, height: 14, alignment: .center).padding(.leading, 15.5)
            }
        }
        // end of whole VStack
        
        
    }
}

struct AgendaView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaView(isLast: false)
    }
}
