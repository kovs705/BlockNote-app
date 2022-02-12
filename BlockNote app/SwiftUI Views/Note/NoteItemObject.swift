//
//  NoteItemObject.swift
//  BlockNote app
//
//  Created by Kovs on 10.01.2022.
//

import SwiftUI
import CoreData
import CodeEditor

//  case Test
//  case Code

//  case TaskBlock          -------- in progress

//  case vocabularyBlock
//  case countDownBlock
//  case emptyBlockTest
//  case NavLink to the next View with tasks, its own color/theme etc

struct NoteItemObject: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var noteItem: NoteItem
    @State var textString: String = ""
    @FocusState var isInputActive: Bool
    
    @State private var height: CGFloat = .zero
    // @State private var noteItemText: String
    
    var body: some View {
        // MARK: - TextBlock
        if noteItem.noteItemType == "Text" {

//            TextView(text: $noteItem.noteItemText)
//                .border(.ultraThickMaterial, cornerRadius: 10)
//                .padding(5)
//                .frame(width: UIScreen.main.bounds.width - 40)
//                .background(Color.darkBack)
//                .font(.system(size: 17))
//                .isScrollEnabled(false)
//                .minHeight(20)
//                // .onSwipeLeft(perform: saveSwipeAction)
            
        // MARK: - CodeBlock
        } else if noteItem.noteItemType == "Code" {
            CodeEditor(source: $noteItem.noteItemText)
                .padding(5)
                .frame(width: UIScreen.main.bounds.width - 30)
                .cornerRadius(15)
                .font(.system(size: 17))
        // MARK: - TaskBlock
        } else {
            Text(noteItem.wrappedNoteItemName)
        }
        
    }
    
    func saveSwipeAction() {
        // hideKeyboard()
        print("Saved!")
        try? viewContext.save()
    }
    
}


struct NoteItemObject_Previews: PreviewProvider {
    
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let newNoteItem = NoteItem(context: moc)
        newNoteItem.noteItemName = "Preview note name"
        newNoteItem.noteItemText = "Some text to show in preview of the NoteItem just for debugging bla bla bla"
        newNoteItem.noteItemOrder = 1
        newNoteItem.noteItemType = "Text"

        
        return NavigationView {
            NoteItemObject(noteItem: newNoteItem)
        }
    }
}
