//
//  BarButton.swift
//  BlockNote
//
//  Created by Kovs on 23.09.2021.
//

import SwiftUI

struct BarButton: View {
    
    // 4 buttons: Themes, Search, Tasks, Settings:
    @Environment(\.colorScheme) public var detectTheme
    
    var body: some View {
        
        HStack {
            Spacer()
            Button(action: {
                // Themes:
            }) {
                ZStack {
                    VStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(Color.textForeground)
                            .font(.system(size: 30))
                    }
                }
                // .padding()
            }
            
            .cornerRadius(20)
            .buttonStyle(BluredButtonInTabBar())
            .padding(5)
            .padding(.vertical, 5)
            // end of the Themes button
            
            Button(action: {
                // Search:
            }) {
                ZStack {
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.textForeground)
                            .font(.system(size: 30))
                    }
                }
                // .padding()
            }
            
            .cornerRadius(20)
            .buttonStyle(BluredButtonInTabBar())
            .padding(5)
            .padding(.vertical, 5)
            
            Button(action: {
                // Tasks:
            }) {
                ZStack {
                    VStack {
                        Image(systemName: "filemenu.and.selection")
                            .foregroundColor(Color.textForeground)
                            .font(.system(size: 30))
                    }
                }
                // .padding()
            }
            
            .cornerRadius(20)
            .buttonStyle(BluredButtonInTabBar())
            .padding(5)
            .padding(.vertical, 5)
            
            Button(action: {
                // Settings:
            }) {
                ZStack {
                    VStack {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(Color.textForeground)
                            .font(.system(size: 30))
                    }
                }
                
            }
            .cornerRadius(20)
            .buttonStyle(BluredButtonInTabBar())
            .padding(3)
            .padding(.vertical, 4)
            
            Spacer()
        }
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(20)
        .frame(width: UIScreen.main.bounds.width - 30, height: 120)
    }

}

struct BarButton_Previews: PreviewProvider {
    static var previews: some View {
        BarButton()
    }
}
