//
//  DictView.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 06.10.2023.
//

import SwiftUI

//struct DictView: View {
//    
//    var coordinator: JMDictCoordinator?
//
//    var body: some View {
//        List {
//            ForEach(dictionary.sorted(by: \.id)) { word in
//                Text((word.kana?.first?.text ?? word.kanji?.first?.text) ?? "Empty")
//            }
//        }
//        .onAppear {
//            coordinator = JMDictCoordinator(reloadCallback: returnElementsIntoSet, returnElementsIntoSet: returnElementsIntoSet)
//            coordinator?.getTheJapaneseData()
//        }
//    }
//    
//    func returnElementsIntoSet(_ elements: [JMDictWord]) {
//        dictionary.append(contentsOf: elements)
//    }
//}

struct DictView: View {
    @StateObject private var coordinator = JMDictCoordinator()

    var body: some View {
        List {
            ForEach(coordinator.dictionary) { word in
                Text((word.kana?.first?.text ?? word.kanji?.first?.text) ?? "Empty")
            }
        }
        .onAppear {
            coordinator.getTheJapaneseData()
        }
    }
}
