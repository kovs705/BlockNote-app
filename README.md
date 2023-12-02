# BlockNote
App project for people who make notes, no matter what they do. You make this app your own by using different and customizable
blocks that you can reorder, change and make new pages from them. Currently you can create the basic group, edit it later, create some notes with the basic blocks:
(spacer, photo, title and text).

## Instalation
- cd to the root directory of the project
- type 'xcodegen generate'
- open newly appeared .xcodeproj file as usual!

## Stack
- Swift, SwiftUI (iOS 16)
- Storyboard, xib/nib, UI Programmatically
- MVP + Builder (UIkit), MVVM (SwiftUI)
- CoreData, UserDefaults
- Apple's Swift markdown
- [CodeEditor](https://github.com/ZeeZide/CodeEditor)
- [SnapKit](https://github.com/SnapKit/SnapKit)
- [Swiftlint](https://github.com/realm/SwiftLint)
- [XCodeGen](https://github.com/yonaskolb/XcodeGen)

## Screenshots
### Main Page VC with CollectionView of groups: (outdated)
<img src="https://user-images.githubusercontent.com/56929597/230763301-967c0952-92e1-4b43-b221-1830224974a5.png" width="356" height="665">  

### Group Detail VC with TableView of notes:
<img src="https://user-images.githubusercontent.com/56929597/230763305-b0ce33bc-33c9-4ae5-a2d4-1b49c2868a68.png" width="356" height="665"> 

### Note detail VC with TableView of NoteItem blocks: Title, Text, Space and Photo blocks:
<img src="https://user-images.githubusercontent.com/56929597/230763309-d40877e0-aa12-45b9-ac50-99ffdcb7509e.png" width="340" height="690"> 


## Requirements
- ***Open project through the 'xcworkspace' file***
- physical iPhone, iPad mini or simulator
- iOS 16.0 minimum

## Things to come
- [in progress] Agenda screen
- App for iPad and Mac
- [in progress] New CollectionView on the main page with notes and groups together
- [80 % completed] Stats (with new attributes for entities to track them): creationDate, summerize the number of blocks creations and so on... 
- [done] Edit screen for groups (colors, emojis, names
