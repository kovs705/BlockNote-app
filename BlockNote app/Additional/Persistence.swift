//
//  Persistence.swift
//  BlockNote
//
//  Created by Kovs on 06.09.2021.
//

import SwiftUI
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    @Environment(\.managedObjectContext) var viewContext

    static var preview: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.viewContext
        
        
        // MARK: - Creating an object:
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Creating the Group:
            // let group = Group(context: viewContext)
            // Creating a Word:
            // let word = Word(context: viewContext)
            
            // Configure Word:
            // word.exactWord = "テスト"
            // word.translation = "Test"
            return true
        }
        
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("SOMETHING WRONG IN S W I F T UIIIII")
            // let nsError = error as NSError
            // fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            
        }
        
        return result
    }()

//    let container: NSPersistentCloudKitContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentCloudKitContainer(name: "BlockNote_app")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//    }
    
    lazy var persistentContainerOffline: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BlockNote_app")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 10
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }
    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {
    }
}

struct WhiteView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<WhiteView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<WhiteView>) {
    }
}

struct AnimatedButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring())
    }
}

