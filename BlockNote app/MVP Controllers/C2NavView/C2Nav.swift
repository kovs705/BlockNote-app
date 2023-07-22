//
//  C2Nav.swift
//  BlockNote app
//
//  Created by user on 22.07.2023.
//

import UIKit
import SpriteKit
import SnapKit

class NavViewController: UIViewController {
    
    let snowBack = SKView()
    var background: UIView!
    var greetingLabel: UILabel!
    var groupCollectionView: UICollectionView!
    var progressBarView: UIView!
    var scrollView: UIScrollView!
    
    var listOfGroups: UIStackView!
    
    var page: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configureSnow() {
        view.addSubviews(snowBack)
        
        snowBack.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func configureScroll() {
        view.addSubviews(scrollView)
        scrollView.backgroundColor = .clear
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func configurePage() {
        scrollView.addSubviews(page)
        
        page.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(scrollView)
        }
    }
    
    func configureGreetingLabel() {
        page.addSubviews(greetingLabel)
        
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(page.snp.top).offset(75)
            make.leading.equalTo(page.snp.leading).offset(40)
            make.trailing.equalTo(page.snp.trailing).offset(-40)
        }
    }
    
    func configureProgressBar() {
        page.addSubviews(progressBarView)
        
        progressBarView.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel).offset(20)
            make.leading.equalTo(page).offset(40)
            make.trailing.equalTo(page).offset(-40)
            make.height.equalTo(200)
        }
    }
    
    func configureListOfGorups() {
        page.addSubviews(listOfGroups)
        listOfGroups.axis = .horizontal
        listOfGroups.alignment = .fill
        listOfGroups.distribution = .equalCentering
        listOfGroups.spacing = 20
        
        listOfGroups.snp.makeConstraints { make in
            make.leading.equalTo(page).offset(40)
            make.trailing.equalTo(page).offset(-40)
            make.top.equalTo(progressBarView).offset(20)
            make.height.equalTo(35)
        }
    }
    
    func configureGroups() {
        let uiview = UIView()
        
        page.addSubviews(uiview)
        uiview.backgroundColor = .black
        
        uiview.snp.makeConstraints { make in
            make.top.equalTo(listOfGroups).offset(15)
            make.leading.equalTo(page.snp.leading).offset(40)
            make.trailing.equalTo(page.snp.trailing).offset(-40)
            make.height.equalTo(400)
            make.bottom.equalTo(page.snp.bottom).offset(15)
        }
        
    }
    
    
    
    
}

