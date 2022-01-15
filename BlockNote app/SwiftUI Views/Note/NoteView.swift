//
//  NoteView.swift
//  BlockNote app
//
//  Created by Kovs on 10.01.2022.
//

import SwiftUI
import CoreData
import UIKit
import UniformTypeIdentifiers // for moving noteItemObjects
import SwiftUIX

struct NoteView: View {
    
    #warning("Work on reordering objects")
    
    @ObservedObject var note: Note
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var pickedObjectType = ["Text", "Code"]
//    @State var draggedObject: NoteItem
//
//    lazy var noteItemObjects = note.noteItemArray.sorted {
//        $0.noteItemOrder < $1.noteItemOrder
//    }
    
    // MARK: - Gesture
    @GestureState var swipeToTheRight = false
//    var swipeGesture: some Gesture {
//        // UISwipeGestureRecognizer()
//    }
    
    // MARK: - buttons back and add
    var buttonBack: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .font(.system(size: 19))
                .foregroundColor(returnColorFromString(nameOfColor: note.typeOfNote?.groupColor ?? "GreenAvocado"))
        }
    }
    // "chevron.left.circle.fill"
    var buttonCreate: some View {
        Button(action: {
            createNoteItem()
        }) {
            Image(systemName: "plus")
                .font(.system(size: 19))
                .foregroundColor(returnColorFromString(nameOfColor: note.typeOfNote?.groupColor ?? "GreenAvocado"))
        }
    }
    
    
    
    // MARK: Body
    var body: some View {
        CocoaScrollView() {
            VStack(alignment: .leading) {
                
                
                // ----------------------
                
                // UITextView
                UITextView()
                    .swiftUIView(layout: .fixedWidth(width: UIScreen.main.bounds.width - 30))
                
                Text(note.wrappedNoteName)
                    .bold()
                    .font(.title)
                    .padding(.horizontal)
                
                // ----------------------
                Divider()
                    .foregroundColor(Color.gray)
                    .padding(.horizontal)
                
                // ----------------------
                LazyVStack {
                    ForEach(note.noteItemArray, id: \.self) { noteItem in
                        NoteItemObject(noteItem: noteItem)
//                            .onDrag({
//                                self.draggedObject = NoteItemObject
//                                return NSItemProvider(item: nil, typeIdentifier: NoteItemObject)
//                            })
                    }
                    
                }
                // ----------------------
                
            }
            // VStack
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        // isInputActive = false
                        hideKeyboard()
                        print("Saved!")
                        try? viewContext.save()
                    }
                }
            }
            // VStack
        }
        .scrollBounceDisabled(false)
        .alwaysBounceVertical(true)
        .alwaysBounceHorizontal(false)
        
        // MARK: - Swipe to the right to close the view:
    
        // ScrollView
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: buttonBack)
        .navigationBarItems(trailing: buttonCreate)
        .navigationBarTitleDisplayMode(.inline)
#warning("Add a picker with different types on blocks")
    }
    
    func createNoteItem() {
        let newNoteItem = NoteItem(context: viewContext)
        newNoteItem.noteItemName = "New Note Item"
        newNoteItem.noteItemText = "Some text to show in preview of the NoteItem just for debugging bla bla bla"
        newNoteItem.noteItemOrder = (note.noteItemArray.last?.noteItemOrder ?? 0) + 1
        // newNoteItem.noteItemOrder = 1
        newNoteItem.noteItemType = "Text"
        
        
        self.note.addObject(value: newNoteItem, forKey: "noteItems")
        
        do {
            try self.viewContext.save()
            print("NoteItem is added!")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

//struct NoteView_Previews: PreviewProvider {
//
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//
//    static var previews: some View {
//        let note = Note(context: moc)
//        note.noteIsMarked = false
//        note.noteName = "Preview Name"
//        note.noteType = "Preview type"
//
//        return NavigationView {
//            NoteView(note: note)
//        }
//    }
//}

// MARK: - Drag and Drop delegate
struct DragAndDropDelegate : DropDelegate {

    let item : NoteItem
    @Binding var items : [NoteItem]
    @Binding var draggedItem : NoteItem?

    func performDrop(info: DropInfo) -> Bool {
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem else {
            return
        }

        if draggedItem != item {
            let from = items.firstIndex(of: draggedItem)!
            let to = items.firstIndex(of: item)!
            withAnimation(.default) {
                self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }
}
