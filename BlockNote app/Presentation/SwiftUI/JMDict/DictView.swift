//
//  DictView.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 06.10.2023.
//

import SwiftUI

struct DictView: View {
    @StateObject private var coordinator = JMDictCoordinator()

    var body: some View {
        ScrollView {
                LazyVStack {
                    ForEach(coordinator.dictionary) { word in
                        HStack {
                            Text((word.kana?.first?.text ?? word.kanji?.first?.text) ?? "Empty")
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                coordinator.getTheJapaneseData()
            }
            .onDisappear {
                coordinator.clearData()
            }
    }
}
