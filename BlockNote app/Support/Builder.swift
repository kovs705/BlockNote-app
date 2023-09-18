//
//  Builder.swift
//  BlockNote app
//
//  Created by Kovs on 08.07.2023.
//

import UIKit

protocol BuilderProtocol {
    func getC2NavView() -> UIViewController?
    func getC2DetailVC(groupType: GroupType) -> UIViewController?
    func getC3NoteDetailVC(note: Note) -> UIViewController?
    func getAgendaVC(group: GroupType) -> UIViewController?
}

final class Builder: BuilderProtocol {

    func getC2NavView() -> UIViewController? {
        guard let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav") as? C2NavViewControllerVC else {
            return nil
        }
        let presenter = C2NavViewControllerPresenter(view: view)
        view.presenter = presenter
        return view
    }

    func getC2DetailVC(groupType: GroupType) -> UIViewController? {
        guard let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as? C2DetailVC else {
            return nil
        }
        let presenter = C2DetailPresenter(view: view, groupType: groupType)
        view.presenter = presenter
        return view
    }

    func getC3NoteDetailVC(note: Note) -> UIViewController? {
        guard let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "noteDetail") as? C3NoteDetailVC else {
            return nil
        }
        let persistenceBC = PersistenceBlockController()
        let presenter = C3NoteDetailPresenter(view: view, persistenceBC: persistenceBC, note: note)
        view.presenter = presenter
        return view
    }

    func getAgendaVC(group: GroupType) -> UIViewController? {
        guard let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "agenda") as? AgendaVC else {
            return nil
        }
        let presenter = AgendaVCPresenter(view: view, group: group)
        view.presenter = presenter
        return view
    }

}
