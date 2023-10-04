//
//  CustomPopoverView.swift
//  BlockNote app
//
//  Created by Kovs on 20.08.2023.
//

import SwiftUI

struct CustomPopoverView<Content: View>: View {
    @Binding var isPresented: Bool
    @GestureState private var translation: CGFloat = 0

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    init(isPresented: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * 0.0
        self.maxHeight = maxHeight
        self.content = content()
        self._isPresented = isPresented
    }

    private var offset: CGFloat {
        isPresented ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.secondary)
            .frame(width: 60, height: 6)
            .onTapGesture {
                isPresented.toggle()
            }
            .accessibility(label: Text("Close"))
            .accessibility(addTraits: .isButton)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                indicator
                    .padding()
                content
            }
            .frame(width: geometry.size.width, height: maxHeight, alignment: .top)
            .background(.ultraThinMaterial) // <- Change this for the background color
            .cornerRadius(16)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(offset + translation, 0))
            .animation(.spring(), value: isPresented)
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * 0.25
                    guard abs(value.translation.height) > snapDistance else { return }
                    isPresented = value.translation.height < 0
                }
            )
        }
        .ignoresSafeArea()
    }
}

struct CustomPopoverView_Preview: PreviewProvider {
    @State static var state: Bool = true
    static var previews: some View {
        CustomPopoverView(isPresented: $state, maxHeight: 100) {
            Text("Hi")
        }
    }
}
