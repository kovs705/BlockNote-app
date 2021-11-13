//
//  Extensions.swift
//  BlockNote
//
//  Created by Kovs on 21.10.2021.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Combine extenstions
extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }

    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}
 // MARK: - KeyboardAdaptive Struct
struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0
    
    func body(content: Content) -> some View {
        
        GeometryReader { geometry in
            content
                .padding(.bottom, self.bottomPadding)
                
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    
                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
            }
                
            .animation(.easeOut(duration: 0.16))
        }
    }
}
 // MARK: - View Extensions
extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}
extension View {
    public func gradientForegroundColor(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(self)
    }
}
// MARK: - BluredButtonInTabBar
struct BluredButtonInTabBar: ButtonStyle {
    @Environment(\.colorScheme) public var detectTheme
    
    func makeBody(configuration: Self.Configuration) -> some View {
        if detectTheme == .dark {
        configuration.label
            .padding(20)
            .cornerRadius(20)
            .background(BlurView(style: .regular))
            // .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .frame(width: 70, height: 69)
        } else {
            configuration.label
                .padding(20)
                .cornerRadius(20)
                .background(Color.white)
                .frame(width: 70, height: 69)
                .shadow(color: .black.opacity(0.3), radius: 10, y: -5)
        }
    }
}
// MARK: - Color Extenstion
extension Color {
    static let darkBack = Color("DarkBackground")
    static let lightPart = Color("LightPart")
    
    // pastel colors:
    static let rosePink = Color("RosePink") // rose
    static let greenAvocado = Color("GreenAvocado") // green
    static let blueBerry = Color("BlueBerry") // blue
    static let yellowLemon = Color("YellowLemon") // yellow
    static let redStrawBerry = Color("RedStrawBerry") // red
    static let purpleBlackBerry = Color("PurpleBlackBerry") // purple
    static let greyCloud = Color("GreyCloud") // grey
    static let brownSugar = Color("BrownSugar") // brown
    
    static let textForeground = Color("TextForeground") // text based on theme (dark and light)
    static let itemListBackground = Color("ItemListBackground")
    
    public static var darkBlue: Color {
        return Color(red: 28 / 255, green: 46 / 255, blue: 74 / 255)
    }
    public static var offWhite: Color {
        return Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    }
    public static var veryDarkBlue: Color {
        return Color(red: 10 / 255, green: 20 / 255, blue: 50 / 255)
    }
    public static var darkGold: Color {
        return Color(red: 133 / 255, green: 94 / 255, blue: 60 / 255)
    }
}
