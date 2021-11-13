//
//  C1NavViewModel.swift
//  BlockNote
//
//  Created by Kovs on 21.10.2021.
//

import Foundation
import SwiftUI
import CoreData

final class C1NavViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Published var isEditing = false
    @Published var onDeleting: Bool = false
    
    var hour = Calendar.current.component(.hour, from: Date())
    
    @Published private var noteName: String = ""
    
    @Published var greeting: String = "BlockNote"
    
    @Published var showBar: Bool = false
    
    @Published var typeName: String = ""
    
    func showGreeting() {
        if hour < 4 {
            greeting = "Have a good night ✨"
        }
        else if hour < 12 {
            greeting = "Good morning!☀️"
        }
        else if hour < 18 {
            greeting = "Have a great day! ⛅️"
        }
        else if hour < 23 {
            greeting = "Good evening 🌇"
        }
        else {
            greeting = "Have a good night ✨"
        }
    }
    
    
}
