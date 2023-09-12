//
//  AgendaVCPresenter.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 12.09.2023.
//

import CoreData
import UIKit
import SwiftUI

protocol AgendaViewProtocol: AnyObject {
    
    
}

protocol AgendaVCPresenterProtocol: AnyObject {
    
    var managedContext: NSManagedObjectContext { get }
    
    init(view: AgendaViewProtocol, group: GroupType)
    var group: GroupType { get set }
    
    func fetchData()
}

final class AgendaVCPresenter: AgendaVCPresenterProtocol {
    
    weak var view: AgendaViewProtocol?
    
    var group: GroupType
    var managedContext: NSManagedObjectContext
    
    required init(view: AgendaViewProtocol, group: GroupType) {
        self.view = view
        self.group = group
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.managedContext = appDelegate.persistentContainerOffline.viewContext
        } else {
            self.managedContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        }
    }
    
    func fetchData() {
        //
    }
    
    
}
