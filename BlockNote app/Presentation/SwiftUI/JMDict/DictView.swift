//
//  DictView.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 06.10.2023.
//

import SwiftUI

struct DictView: View {
    @State private var dictionary: [JMDictWord] = []
//    var coordinator = JMDictCoordinator(reloadCallback: returnElementsIntoSet, returnElementsIntoSet: returnElementsIntoSet)

    var body: some View {
        List {
            ForEach(dictionary.sorted(by: \.id)) { word in
                Text((word.kana?.first?.text ?? word.kanji?.first?.text) ?? "Empty")
            }
        }
        .onAppear {
            JMDictCoordinator(reloadCallback: returnElementsIntoSet, returnElementsIntoSet: returnElementsIntoSet).getTheJapaneseData()
        }
    }
    
    func returnElementsIntoSet(_ elements: [JMDictWord]) {
        dictionary.append(contentsOf: elements)
    }
}
