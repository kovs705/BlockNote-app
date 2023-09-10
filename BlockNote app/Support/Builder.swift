//
//  Builder.swift
//  BlockNote app
//
//  Created by Kovs on 08.07.2023.
//

import UIKit

protocol BuilderProtocol {
    func getC2NavView() -> UIViewController
    func getC2DetailVC(groupType: GroupType) -> UIViewController
    func getC3NoteDetailVC(note: Note) -> UIViewController
}

final class Builder: BuilderProtocol {
    
    func getC2NavView() -> UIViewController {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav") as! C2NavViewControllerVC
        let presenter = C2NavViewControllerPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    func getC2DetailVC(groupType: GroupType) -> UIViewController {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as! C2DetailVC
        let presenter = C2DetailPresenter(view: view, groupType: groupType)
        view.presenter = presenter
        return view
    }
    
    func getC3NoteDetailVC(note: Note) -> UIViewController {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "noteDetail") as! C3NoteDetailVC
        let persistenceBC = PersistenceBlockController()
        let presenter = C3NoteDetailPresenter(view: view, persistenceBC: persistenceBC, note: note)
        view.presenter = presenter
        return view
    }
    
    
}
