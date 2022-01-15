//
//  GroupDetailView.swift
//  BlockNote app
//
//  Created by Kovs on 10.01.2022.
//

import SwiftUI
import CoreData

    /// create a button to mark the note as completed
    /// make a list of the nortes inside a group
    /// make the button to delete the group with all the notes inside (ask a user to delete in or not)
    /// make an ability to put a red flag on notes that are important
    /// --------------------------------

struct GroupDetailView: View {
//    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(key: "noteID", ascending: true)]) var notes: FetchedResults<Note>
    @ObservedObject var groupType: GroupType
    
    @Environment(\.managedObjectContext) var viewContext
//    @Environment(\.colorScheme) public var detectTheme
//    @Environment(\.defaultMinListRowHeight) var minRowHeight // for the list
    
    // @State var funcWithNavLink: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                // MARK: - TopBar Statistics
                GeometryReader { geometry in
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(returnColorFromString(nameOfColor: groupType.groupColor ?? "GreenAvocado"))
                            .cornerRadius(20)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 150, alignment: .center)
                            .shadow(color: returnColorFromString(nameOfColor: groupType.groupColor ?? "GreenAvocado"), radius: 10, y: 5)
                        
                        // MARK: - Words and Numbers
                        HStack {
                            VStack {
                                Spacer()
                                Text("Notes: ")
                                    .bold()
                                    .font(.system(size: 16))
                                    .foregroundColor(Color.textForeground)
                                
                                Spacer()
                                
                                Text("Completed: ")
                                    .foregroundColor(Color.textForeground)
                                    
                                    .bold()
                                    .font(.system(size: 16))
                                Spacer()
                            } // first column
                            .padding()
                            
                            VStack {
                                Spacer()
                                Text("\(groupType.typesOfNoteArray.count)") // that should work, I guess..
                                    .font(.system(size: 16))
                                Spacer()
                                Text("Nothing yet!")
                                    .font(.system(size: 14))
                                    .padding(.horizontal)
                                Spacer()
                            }
                            
                            Spacer()
                            
                            // MARK: - Buttons
                            VStack {
                                Button(action: {
                                // action to open Tasks of the group:
                                    
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(returnColorFromString(nameOfColor: groupType.groupColor ?? "GreenAvocado"))
                                            .frame(width: 75, height: 75)
                                            .shadow(color: .black.opacity(0.25), radius: 10, y: 5)
                                        Image(systemName: "list.bullet.rectangle")
                                            .font(.system(size: 32))
                                            .foregroundColor(Color.textForeground)
                                    }
                                }
                                .buttonStyle(AnimatedButton())
                                Button(action: {
                                    // action to create an empty note:
                                    createNote()
                                    // MARK: Put a navigationLink here:
                                    //
                                }) {
                                    #warning("Think about making buttons standing out of the panel")
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(returnColorFromString(nameOfColor: groupType.groupColor ?? "GreenAvocado"))
                                            // .saturation(0.8)
                                            .frame(width: 75, height: 75)
                                            .shadow(color: .black.opacity(0.25), radius: 10, y: 5)
                                        Image(systemName: "plus")
                                            .font(.system(size: 32))
                                            .foregroundColor(Color.textForeground)
                                    }
                                }
                                .buttonStyle(AnimatedButton())
                            }
                            Spacer()
                        }
                        .padding()
                        
                    }
                    // .frame(width: UIScreen.main.bounds.width - 30, height: 150, alignment: .center)
                    .frame(height: 150, alignment: .center)
                    .ignoresSafeArea(.all)
                    // end of ZStack
                }
                .frame(height: 150)
                .ignoresSafeArea(.all)
                // end of the TopBar Statistics
                
                
                // MARK: - List of notes
                VStack {
//                    Text("Test")
//                        .padding()
                    ForEach(self.groupType.typesOfNoteArray, id: \.self) { note in
                        NavigationLink(destination: NoteView(note: note)) {
                        // NavigationLink(destination: C1NoteView(note: note)) {
                            HStack {
                                Text(note.wrappedNoteName)
                                    .foregroundColor(Color.textForeground)
                            }
                        }
                    }
                    .padding()
                    // ForEach
                }
                // inner VStack
            }
            .ignoresSafeArea(.all)
            // VStack
        }
        // ScrollView
        .navigationBarItems(trailing: Button(action: {
            // to add a new Note // delete note for now
            deleteGroup(groupName: groupType.wrappedGroupName)
        }) {
            Image(systemName: "trash")
                .font(.system(size: 17))
        })
        .navigationTitle(groupType.wrappedGroupName)
        .background(Color.darkBack)
        
    }
    
    
    
    // MARK: - delete the group and its notes
    func deleteGroup(groupName: String) {
        
        if groupType.wrappedGroupName == groupName {
            
            if !self.groupType.typesOfNoteArray.isEmpty {
                for noteObject in self.groupType.typesOfNoteArray {
                    self.viewContext.delete(noteObject) // if array is not empty - delete every note it has
                }
            } else {
                print("No notes in array")
            }
            
            self.viewContext.delete(self.groupType)
            
            do {
                try self.viewContext.save()
            } catch {
                print("Something went wrong while deleting the group and note!!")
            }
        } else {
            print("Something wrong on checking the name of the group!")
        }
    }
    
    // MARK: - Creating NOTE
    func createNote() {
        withAnimation {
            let newNote = Note(context: self.viewContext)
            // newNote.typeOfNote = GroupType(context: self.viewContext)
            
            if self.groupType.wrappedGroupName == "" {
                newNote.noteType = "Yo, the type of note is UNKNOWN"
            } else {
                newNote.noteType = self.groupType.wrappedGroupName // name of the group will be the same as on the page, which is opened by user
            }
            
            newNote.noteLevel = "TEST LEVEL" // note lvl or whatever it can be for user
            // newNote.noteID = (notes.last?.noteID ?? 0) + 1 // note id, which will place notes in the right order
            
            newNote.noteName = "CREATED NOTE TEST \(newNote.noteID)" // note name
            newNote.noteIsMarked = false // note isn't marked yet, so user can do it later
            
            // TODO: - Append the note to the group:
            self.groupType.addObject(value: newNote, forKey: "noteTypes")
            
            do {
                try self.viewContext.save()
                
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - Preview
struct GroupDetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let groupType = GroupType(context: moc)
        groupType.groupName = "Test Group name"
        groupType.groupColor = "GreenAvocado"
        
        return NavigationView {
            GroupDetailView(groupType: groupType)
        }
    }
}
