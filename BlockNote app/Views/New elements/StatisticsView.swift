//
//  StatisticsView.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 23.09.2023.
//

import SwiftUI

struct StatisticsView: View {
    
    @State var gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
//        VStack {
            ScrollView {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                    RoundedContent()
                    RoundedContent()
                    RoundedContent()
                    RoundedContent()
                }
            }
            .padding(10)
            .animation(.interactiveSpring(duration: 0.4, extraBounce: 0.1), value: gridLayout.count)
//            
//            Button(action: {
//                gridLayout = Array(repeating: .init(.flexible()), count: self.gridLayout.count % 4 + 1)
//            }, label: {
//                Text("Change layout")
//            })
//        }
    }
    
    @ViewBuilder func RoundedContent() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
            Text("Hello")
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: gridLayout.count == 1 ? 200 : 100)
        .cornerRadius(10)
        .shadow(color: Color.primary.opacity(0.3), radius: 1)
    }

}

#Preview {
    StatisticsView()
        .frame(width: .infinity, height: 250)
}
