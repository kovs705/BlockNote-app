//
//  C2DetailPresenter.swift
//  BlockNote app
//
//  Created by Kovs on 08.07.2023.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    
}

protocol DetailPresenterProtocol: AnyObject {
    
    init(view: DetailViewProtocol)
}

final class DetailPresenter: DetailPresenterProtocol {
    
    weak var view: DetailViewProtocol?
    
    required init(view: DetailViewProtocol) {
        self.view = view
    }
    
    
}
