//
//  AgendaVC.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 12.09.2023.
//

import UIKit
import SwiftUI
import SnapKit

class AgendaVC: UIViewController {
    
    var presenter: AgendaVCPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: TimeAgendaView(viewModel: TimeAgendaViewModel(), group: presenter.group))
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
    }
    

}

extension AgendaVC: AgendaViewProtocol {
    
}
