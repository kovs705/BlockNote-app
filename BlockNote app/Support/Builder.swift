//
//  Builder.swift
//  BlockNote app
//
//  Created by Kovs on 08.07.2023.
//

import UIKit

protocol BuilderProtocol {
    func getC2NavView() -> UIViewController
    func getC2DetailVC() -> UIViewController
//    func getC3NoteDetailVC() -> UIViewController
}

final class Builder: BuilderProtocol {
    
    func getC2NavView() -> UIViewController {
        let view = C2NavViewControllerVC()
        let presenter = C2NavViewControllerPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    func getC2DetailVC() -> UIViewController {
        let view = C2DetailVC()
        let presenter = C2DetailPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
//    func getC3NoteDetailVC() -> UIViewController {
//        // code to come
//        return view
//    }
    
    // TODO: Make a second project to code UI there and then place it in app here
    
    
}
