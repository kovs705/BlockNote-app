//
//  Constants.swift
//  BlockNote app
//
//  Created by Kovs on 01.02.2023.
//

import UIKit

enum Block {
    static let textBlock = "TextBlock"
    static let photoBlock = "PhotoBlock"
    static let titleBlock = "TitleBlock"
    static let spaceBlock = "SpaceBlock"
    
    static let blockToSave = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. MEOW"
    static let titleToSave = "Lorem ipsum title"
}

enum Cells {
    static let groupDetail = "groupDetail"
    static let noteDetail = "noteDetail"
    static let noteViewCell = "NoteViewCell"
}

enum Keys {
    // group
    static let gName = "groupName"
    static let gColor = "groupColor"
    static let gNumber = "number"
    static let noteTypes = "noteTypes"
    
    // note
    static let nID = "noteID"
    static let nName = "noteName"
    static let nLevel = "noteLevel"
    static let nType = "noteType"
    static let nItems = "noteItems"
    static let nMarked = "noteIsMarked"
    static let nTypeOfNote = "typeOfNote"
    static let agendaItems = "agendaItems"
    
    // noteItem
    static let niOrder = "noteItemOrder"
    static let niType = "noteItemType"
    static let niLastChanged = "lastChangedNI"
    static let niPhoto = "noteItemPhoto"
    static let niText = "noteItemText"
    static let niNote = "note"
    
    // agenda
    static let aName = "name"
    static let aDesc = "desc"
    static let aStart = "dateStart"
    static let aEnd = "dateEnd"
    static let aColor = "color"
    static let aIsImportant = "isImportant"
    static let aIsDone = "isDone"
    static let aNote = "note"
}

enum GreetingPhrases {
    static let night = "Have a good night ✨"
    static let morning = "Good morning!☀️"
    static let day = "Have a great day! ⛅️"
    static let evening = "Good evening 🌇"
}

enum AssetsColor: String {
    case BlueBerry
    case BrownSugar
    case DarkBackground
    case GreenAvocado
    case GreyCloud
    case LightPart
    case PurpleBlackBerry
    case RedStrawBerry
    case RosePink
    case TextForegroundColor
    case YellowLemon
}

