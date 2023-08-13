//
//  C2NavViewPresenter.swift
//  BlockNote app
//
//  Created by Kovs on 29.06.2023.
//

import CoreData
import UIKit
import SwiftUI

protocol C2NavViewControllerViewProtocol: AnyObject {
    var sortingKey: String { get set }
    
    func updateData()
    func update()
    
    func performTransition(to vc: UIViewController)
    func showGreeting(with text: String)
}

protocol C2NavViewControllerPresenterProtocol: AnyObject {
    
    init(view: C2NavViewControllerViewProtocol)
    var groups: [NSManagedObject] { get set }
    var hour: Int { get set }
    
    func fetchData(using sort: String)
    func save(groupName: String, groupColor: String)
    
    func manageGreeting()
    
    func performTransitionToDetailVC(groupType: GroupType)
    func showGroupEdit(group: GroupType)
}

final class C2NavViewControllerPresenter: C2NavViewControllerPresenterProtocol {
    
    weak var view: C2NavViewControllerViewProtocol?
    
    var groups: [NSManagedObject] = []
    var hour = Calendar.current.component(.hour, from: Date())
    
    required init(view: C2NavViewControllerViewProtocol) {
        self.view = view
    }
    
    func fetchData(using sort: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext       = appDelegate.persistentContainerOffline.viewContext
        let fetchRequest      = NSFetchRequest<NSManagedObject>(entityName: "GroupType")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sort, ascending: false)]
        
        do {
            groups = try viewContext.fetch(fetchRequest)
            self.view?.updateData()
        } catch let error as NSError {
            print("Couldn't fetch: \(error), \(error.userInfo)")
        }
    }
    
    func save(groupName: String, groupColor: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext =
        appDelegate.persistentContainerOffline.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "GroupType", in: managedContext) else { return }
        guard let agendaEntity = NSEntityDescription.entity(forEntityName: "Agenda", in: managedContext) else { return }
        
        let newAgenda = NSManagedObject(entity: agendaEntity,
                                        insertInto: managedContext)
        
        
        let newGroup = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        
        newGroup.setValue(groupName, forKey: Keys.gName)
        newGroup.setValue(groupColor, forKey: Keys.gColor)
        if groups.isEmpty {
            newGroup.setValue(1, forKey: Keys.gNumber)
        } else {
            newGroup.setValue((groups.count) + 1, forKey: Keys.gNumber)
        }
        
        newAgenda.setValue("Name", forKey: "name")
        newGroup.addObject(value: newAgenda, forKey: "agendaItems")
        
        do {
            groups.insert(newGroup, at: 0)
            print("Successfully added")
            try managedContext.save()
            
            self.view?.updateData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func manageGreeting() {
        switch hour {
        case 0..<4:
            view?.showGreeting(with: GreetingPhrases.night)
        case 4..<12:
            view?.showGreeting(with: GreetingPhrases.morning)
        case 12..<18:
            view?.showGreeting(with: GreetingPhrases.day)
        case 18..<23:
            view?.showGreeting(with: GreetingPhrases.evening)
        default:
            view?.showGreeting(with: GreetingPhrases.night)
        }
    }
    
    // MARK: - Transition
    func performTransitionToDetailVC(groupType: GroupType) {
        let coordinator = Builder()
        let detailVC = coordinator.getC2DetailVC(groupType: groupType)
//        detailVC.modalTransitionStyle = .coverVertical
        detailVC.modalTransitionStyle = .crossDissolve
        detailVC.modalPresentationStyle = .currentContext
//        detailVC.modalPresentationStyle = .fullScreen
        
        self.view?.performTransition(to: detailVC)
    }
    
    func showGroupEdit(group: GroupType) {
        let groupEditView = C2GroupView(viewModel: C2GroupViewModel(), group: group)
        let editVC = UIHostingController(rootView: groupEditView)
        self.view?.performTransition(to: editVC)
    }
}
