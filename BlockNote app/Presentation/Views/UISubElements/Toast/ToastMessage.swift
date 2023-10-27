//
//  ToastMessage.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 12.10.2023.
//

import SwiftUI

extension View {

    public func present<MessageContent: View>(
        isPresented: Binding<Bool>,
        type: MessageView<MessageContent>.MessageType = .alert,
        position: MessageView<MessageContent>.Position = .bottom,
        animation: Animation = Animation.easeOut(duration: 0.3),
        autohideDuration: Double? = 3.0,
        closeOnTap: Bool = true,
        onTap: (() -> Void)? = nil,
        closeOnTapOutside: Bool = false,
        view: @escaping () -> MessageContent) -> some View {
        self.modifier(
            MessageView(
                isPresented: isPresented,
                type: type,
                position: position,
                animation: animation,
                autohideDuration: autohideDuration,
                closeOnTap: closeOnTap,
                onTap: onTap ?? {},
                closeOnTapOutside: closeOnTapOutside,
                view: view)
        )
    }
    
    func applyIf<T: View>(_ condition: @autoclosure () -> Bool, apply: (Self) -> T) -> AnyView {
        if condition() {
            return AnyView(apply(self))
        } else {
            return AnyView(self)
        }
    }
}
