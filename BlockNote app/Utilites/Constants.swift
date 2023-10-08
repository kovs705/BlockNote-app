//
//  Constants.swift
//  BlockNote app
//
//  Created by Kovs on 01.02.2023.
//

import UIKit

enum Icons {
    static let addGroup = "plus.rectangle.on.rectangle"
}

enum BlockCases {
    case title, text, space, photo
}

enum SortOrder {
    static let optimized        = "number"
    static let title            = "groupName"
    static let lastChangedGroup = "lastChangedGroup"
    static let lastOpened       = "lastOpened"
}

enum Entities {
    static let noteItem = "NoteItem"
    static let group    = "GroupType"
    static let note     = "Note"
    static let agenda   = "Agenda"
}

enum Block {
    static let textBlock  = "TextBlock"
    static let photoBlock = "PhotoBlock"
    static let titleBlock = "TitleBlock"
    static let spaceBlock = "SpaceBlock"

    static let blockToSave = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. MEOW"
    static let titleToSave = "Lorem ipsum title"
}

enum Cells {
    static let groupDetail  = "groupDetail"
    static let noteDetail   = "noteDetail"
    static let noteViewCell = "NoteViewCell"
}

enum Keys {
    // group
    static let gName             = "groupName"
    static let gColor            = "groupColor"
    static let gNumber           = "number"
    static let gCreationDate     = "creationDate"
    static let glastChangedGroup = "lastChangedGroup"
    static let glastOpened       = "lastOpened"
    static let noteTypes         = "noteTypes"

    // note
    static let nID           = "noteID"
    static let nName         = "noteName"
    static let nLevel        = "noteLevel"
    static let nType         = "noteType"
    static let nItems        = "noteItems"
    static let nMarked       = "noteIsMarked"
    static let nTypeOfNote   = "typeOfNote"
    static let agendaItems   = "agendaItems"
    static let nCreationDate = "creationDate"

    // noteItem
    static let niOrder        = "noteItemOrder"
    static let niType         = "noteItemType"
    static let niLastChanged  = "lastChangedNI"
    static let niCreationDate = "creationDate"
    static let niPhoto        = "noteItemPhoto"
    static let niText         = "noteItemText"
    static let niNote         = "note"

    // agenda
    static let aName         = "name"
    static let aDesc         = "desc"
    static let aStart        = "dateStart"
    static let aEnd          = "dateEnd"
    static let aCreationDate = "creationDate"
    static let aColor        = "color"
    static let aIsImportant  = "isImportant"
    static let aIsDone       = "isDone"
    static let aNote         = "note"
}

enum GreetingPhrases {
    static let night    = "Have a good night ✨"
    static let morning  = "Good morning!☀️"
    static let day      = "Have a great day! ⛅️"
    static let evening  = "Good evening 🌇"
}

enum AssetsColor: String, CaseIterable {
    case blueBerry           = "blueBerry"
    case brownSugar          = "brownSugar"
    case darkBackground      = "darkBackground"
    case greenAvocado        = "greenAvocado"
    case greyCloud           = "greyCloud"
    case lightPart           = "lightPart"
    case purpleBlackBerry    = "purpleBlackBerry"
    case redStrawBerry       = "redStrawBerry"
    case rosePink            = "rosePink"
    case textForegroundColor = "TextForegroundColor"
    case yellowLemon         = "yellowLemon"
}

enum GroupColor: String, CaseIterable {
    case blueBerry        = "blueBerry"
    case brownSugar       = "brownSugar"
    case greenAvocado     = "greenAvocado"
    case greyCloud        = "greyCloud"
    case purpleBlackberry = "purpleBlackBerry"
    case redStrawBerry    = "redStrawBerry"
    case rosePink         = "rosePink"
    case yellowLemon      = "yellowLemon"
}
