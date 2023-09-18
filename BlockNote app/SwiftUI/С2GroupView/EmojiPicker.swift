//
//  EmojiPicker.swift
//  BlockNote app
//
//  Created by Kovs on 13.08.2023.
//

import SwiftUI

struct EmojiPicker: View {

    @Environment(\.presentationMode) var presentationMode

    @State var emojies: [String] = []
    @State private var type: EmojiType = .emoticons
    let columns = [GridItem(.flexible(minimum: 55, maximum: 55)), GridItem(.flexible(minimum: 55, maximum: 55)), GridItem(.flexible(minimum: 55, maximum: 55))]

    var action: (String) -> Void

    var body: some View {
        VStack {
            Picker(selection: $type) {
                ForEach(EmojiType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            } label: {
                Text("Emoji picker")
            }
            .pickerStyle(.menu)
            .padding(.top, 15)

            ScrollView(.horizontal) {
                LazyHGrid(rows: columns) {
                    ForEach(emojies, id: \.self) { emoji in
                        Button {
                            action(emoji)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color("back")).opacity(0.5)
                                    .frame(width: 50, height: 50)
                                Text(emoji)
                                    .font(.system(size: 35))
                            }
                        }
                    }
                }
                .padding()
                .onAppear {
                    giveEmojies()
                }
            }
            .onChange(of: type, perform: { _ in
                giveEmojies()
            })
        }
        .background(BackgroundClearView())
    }

    func giveEmojies() {
        switch type {
        case .letters:
            emojies = createEmojies(start: 0x1F1E6, end: 0x1F1FF)
        case .misc:
            emojies = createEmojies(start: 0x1F680, end: 0x1F6FF)
        case .emoticons:
            emojies = createEmojies(start: 0x1F600, end: 0x1F64F)
        case .symbols:
            emojies = createEmojies(start: 9100, end: 9300)
        }
    }

    func createEmojies(start: Int, end: Int) -> [String] {
        var emojies: [String] = []
        for i in start...end {
            let c = String(UnicodeScalar(i) ?? "-")
            emojies.append(c)
        }
        return emojies
    }
}

// struct EmojiPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiPicker()
//    }
// }

enum EmojiType: String, CaseIterable {
    case letters     = "Letters"
    case misc        = "Misc items"
    case emoticons   = "Emoticons"
    case symbols     = "B&W Symbols"
}
