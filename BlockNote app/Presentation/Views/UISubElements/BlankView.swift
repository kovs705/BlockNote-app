//
//  BlankView.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 25.09.2023.
//

import SwiftUI

struct BlankView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.purpleBlackBerry)
            Button(action: {}, label: {
                Text("Button me")
            })
        }
    }
}

#Preview {
    BlankView()
}
