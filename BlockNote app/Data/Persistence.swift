//
//  Persistence.swift
//  BlockNote
//
//  Created by Kovs on 06.09.2021.
//

import SwiftUI
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    @Environment(\.managedObjectContext) var viewContext
    let cachePhoto = NSCache<NSString, NSData>()
    let cacheString = NSCache<NSString, NSString>()

    static var preview: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.viewContext
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            return true
        }
        
        do {
            try viewContext.save()
        } catch let error as NSError {
            print(error)
            fatalError()
        }
        
        return result
    }()
    
//    func ultimateSave(for entity: String, blockType: BlockCases, in object: NSManagedObject, blockText: String?, usingArray: [NSManagedObject], tableView: UITableView) {
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        
//        let managedContext = appDelegate.persistentContainerOffline.viewContext
//        
//        guard let entity = NSEntityDescription.entity(forEntityName: entity, in: managedContext) else { return }
//        
//        switch blockType {
//           case .title:
//            C1NoteDetailExt().save(blockType: <#T##String#>, blockText: <#T##String#>, noteListTB: <#T##UITableView#>)
//            C1NoteDetailExt().sortAndUpdate()
//            
//                // case .text:
//            
//        case .space:
//            <#code#>
//        case .photo:
//            <#code#>
//        }
//        
//    }

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
    var scale: CGFloat = 1.0
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: scale)
//            .animation(.spring())
    }
}

