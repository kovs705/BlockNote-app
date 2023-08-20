//
//  EmojiPicker.swift
//  BlockNote app
//
//  Created by Kovs on 13.08.2023.
//

import SwiftUI

struct EmojiPicker: View {
    
    @State var emojies: [String] = []
    @State private var type: EmojiType = .emoticons
    let columns = [GridItem(.flexible(minimum: 55, maximum: 55)), GridItem(.flexible())]
    
    var body: some View {
        Form {
            VStack {
                Picker(selection: $type) {
                    ForEach(EmojiType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                } label: {
                    Text("Text")
                }
                .pickerStyle(.menu)
                
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: columns) {
                        ForEach(emojies, id: \.self) { emoji in
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white).opacity(0.5)
                                    .frame(width: 50, height: 50)
                                Text(emoji)
                                    .font(.system(size: 35))
                            }
                        }
                    }
                    .padding()
//                    .background(.ultraThinMaterial)
                    .onAppear {
                        giveEmojies(type: .emoticons)
                    }
                }
            }
        }
        .background(.blue)
//        .background(.ultraThinMaterial)
        .scrollContentBackground(.hidden)
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

enum EmojiType: String, CaseIterable {
    case flags     = "Flags"
    case transport = "Transport"
    case emoticons = "Emoticons"
    case miscItems = "Misc items"
}
