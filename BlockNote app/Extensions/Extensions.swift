//
//  Extensions.swift
//  BlockNote
//
//  Created by Kovs on 21.10.2021.
//

import Foundation
import SwiftUI
import Combine

extension UIView {
    // незаменимый помощник быстро добавить массив из вьюх (UIButton, UIView, UILabel и тд.)
    // пример: view.addSubviews(button, layer, image) - всё.
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    // быстро добавить тень к любой вьюхе, одной строчкой (аналогично примеру вызова функции выше)
    func addShadow(color: CGColor, opacity: Float, shadowOffset: CGSize, shadowRadius: CGFloat) {
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    // анимирование надавливания для кнопок
    func animatePressing(isRestoring: Bool) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
            if !isRestoring {
                // пользователь опустил палец на кнопку
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } else {
                // пользователь убрал палец и нужно вернуть кнопку в прежнее состояние
                self.transform = .identity
            }
        }
    }
}

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
                    withAnimation(.easeOut(duration: 0.16)) {
                        let keyboardTop = geometry.frame(in: .global).height - keyboardHeight

                        let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0

                        self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                    }
            }
//            .animation(.easeOut(duration: 0.16))
        }
    }
}

// MARK: - View Extensions
extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }

    func gradientForegroundColor(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
            .mask(self)
    }
}

// MARK: - Transparent back for sheets
extension View {

    func blurredSheet<Content: View>(_ style: AnyShapeStyle, show: Binding<Bool>, onDismiss: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .sheet(isPresented: show, onDismiss: onDismiss, content: {
                content()
                    .background(BackgroundClearView())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        Rectangle()
                            .fill(style)
                            .ignoresSafeArea(.container, edges: .all)
                    }
            })
    }

}

struct BackgroundClearView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
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
    static let frontBack = Color("FrontBack")
    
    static let rosePink = Color("RosePink") // Rose
    static let greenAvocado = Color("GreenAvocado") // Green
    static let blueBerry = Color("BlueBerry") // Blue
    static let yellowLemon = Color("YellowLemon") // Yellow
    static let redStrawBerry = Color("RedStrawBerry") // Red
    static let purpleBlackBerry = Color("PurpleBlackBerry") // Purple
    static let greyCloud = Color("GreyCloud") // Grey
    static let brownSugar = Color("BrownSugar") // Brown

    static let backWhite = Color("BackWhite")
    static let backBlock = Color("BackBlock")

    static let textForeground = Color("TextForegroundColor") // Text based on theme (dark and light) light)
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

func returnColorFromString(nameOfColor: String) -> Color {
    return Color.init(nameOfColor)
}

func returnUIColorFromString(string: String) -> UIColor? {
    // return UIColor.init(Color.init(string))
    return UIColor(named: string)
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
    static func getUIColor(_ name: String) -> UIColor? {
        return UIColor(named: name)
    }
}

extension UIImage {
    var toData: Data? {
        return pngData()
    }

    func getCropRatio() -> CGFloat {
        let widthRatio = self.size.width / self.size.height
        return widthRatio
    }
}

extension UITableView {

    func getAllCells() -> [UITableViewCell] {
        var cells = [UITableViewCell]()
        for i in 0..<self.numberOfSections {
            for j in 0..<self.numberOfRows(inSection: i) {
                if let cell = self.cellForRow(at: IndexPath(row: j, section: i)) {
                    cells.append(cell)
                }
            }
        }
        return cells
    }

}
