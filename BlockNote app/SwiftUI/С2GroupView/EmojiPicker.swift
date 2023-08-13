//
//  EmojiPicker.swift
//  BlockNote app
//
//  Created by Kovs on 13.08.2023.
//

import SwiftUI

struct EmojiPicker: View {
    
    @State var emojies: [String] = []
    
    var body: some View {
        LazyHStack(spacing: 8) {
            ForEach(emojies, id: \.self) { emoji in
                Text(emoji)
            }
        }
        .background(.ultraThinMaterial)
        .onAppear {
            giveEmojies(type: .emoticons)
        }
    }
    
    func giveEmojies(type: EmojiType) {
        emojies.removeAll()
        
        switch type {
        case .flags:
            createEmojies(start: 0x1F1E6, end: 0x1F1FF)
        case .transport:
            createEmojies(start: 0x1F680, end: 0x1F6FF)
        case .emoticons:
            createEmojies(start: 0x1F600, end: 0x1F64F)
        case .miscItems:
            createEmojies(start: 9100, end: 9300)
        }
    }
    
    func createEmojies(start: Int, end: Int) {
        for i in start...end {
            let c = String(UnicodeScalar(i) ?? "-")
            withAnimation(.spring()) {
                emojies.append(c)
            }
        }
    }
}

struct EmojiPicker_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPicker()
    }
}

enum EmojiType {
    case flags
    case transport
    case emoticons
    case miscItems
}
