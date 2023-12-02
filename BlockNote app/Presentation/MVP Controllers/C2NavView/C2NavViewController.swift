//
//  C2NavViewController.swift
//  BlockNote app
//
//  Created by Kovs on 29.06.2023.
//

import UIKit
import SwiftUI
import SpriteKit
import SnapKit

protocol SKSnowScene {
    func initSnowScene(snowBack: SKView)
}

class C2NavViewControllerVC: UIViewController {

    @IBOutlet weak var page: UIView!
    @IBOutlet var background: UIView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var groupCollectionView: UICollectionView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var snowBackgroundScene: SKView!
    
    @IBOutlet weak var listOfGroups: UIStackView!
    var emptyTitle = UILabel()
    var back       = UIView()

    var thinStatusBar = UIVisualEffectView()
    var thinProgress  = UIVisualEffectView()
    
    var presenter: C2NavViewControllerPresenterProtocol!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.fetchData(using: SortOrder.optimized)

        configureProgressBarView(progressBarView: progressBarView)
        configureGroupCollectionView(gCV: groupCollectionView)
        initSnowScene(snowBack: snowBackgroundScene)
        presenter.manageGreeting()

        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        configureStatusBar()
        
        configureStatisticsView()
        configureEmptyView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        presenter.fetchData(using: SortOrder.lastOpened)
        thinStatusBar.alpha = 0.0
        
        checkOnNotes()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - IBActions
    @IBAction func addGroup(_ sender: UIButton) {
        let alert = UIAlertController(title: "New group", message: "Enter a name for the group", preferredStyle: .alert)

        // save action button
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let self = self else { return }

            guard
                let textField = alert.textFields?.first,
                let groupToSave = textField.text
            else {
                return
            }

            self.presenter.save(groupName: groupToSave, groupColor: GroupColor.allCases.randomElement()?.rawValue ?? "GreenAvocado")
            
        }
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)

    }

    @IBAction func SortCV(_ sender: UIButton) {
        let alertSheet = UIAlertController(title: "Sort by..", message: "", preferredStyle: .actionSheet)

        let optimized = UIAlertAction(title: "Number", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.fetchData(using: SortOrder.optimized)
        }

        let title = UIAlertAction(title: "Name", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.fetchData(using: SortOrder.title)
        }
        let lastChangedGroup = UIAlertAction(title: "Creation date", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.fetchData(using: SortOrder.lastChangedGroup)
        }
        
        let lastOpened = UIAlertAction(title: "Last opened", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.fetchData(using: SortOrder.lastOpened)
        }

        let cancelButton = UIAlertAction(title: "cancel", style: .cancel)

        alertSheet.addAction(title)
        alertSheet.addAction(optimized)
        alertSheet.addAction(lastChangedGroup)
        alertSheet.addAction(lastOpened)

        alertSheet.addAction(cancelButton)

        present(alertSheet, animated: true)
    }

    // MARK: - UI configurations
    private func configureProgressBarView(progressBarView: UIView) {
        progressBarView.layer.masksToBounds = false
        progressBarView.layer.cornerRadius = 20
        
    }

    // MARK: status bar
    func configureStatusBar() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        view.addSubviews(thinStatusBar)
        thinStatusBar.backgroundColor = .clear
        thinStatusBar.effect = blurEffect

        thinStatusBar.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.width.equalTo(view.snp.width)
            make.top.equalTo(view)
        }
    }
    
    func configureStatisticsView() {
        let hostingController = UIHostingController(rootView: BlankView())
        let statView = hostingController.view!
        progressBarView.addSubviews(statView)

        statView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(progressBarView)
        }
        
        statView.cornerRadius = 20
    }
    
    // MARK: Empty view config
    func configureEmptyView() {
        page.addSubviews(back)
        back.backgroundColor = UIColor(Color.frontBack)
        back.layer.cornerRadius = 25
        
        back.snp.makeConstraints { make in
            make.top.equalTo(listOfGroups.snp.bottom).offset(15)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            make.height.greaterThanOrEqualTo(50)
        }
        
        back.addSubviews(emptyTitle)
        
        emptyTitle.snp.makeConstraints { make in
            make.centerX.equalTo(back.snp.centerX)
            make.centerY.equalTo(back.snp.centerY)
        }
        
        emptyTitle.text = "No groups.\nClick + to add a new one!"
        emptyTitle.numberOfLines = 0
        emptyTitle.textAlignment = .center
        emptyTitle.textColor = UIColor.white
        emptyTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        
        back.isHidden = true
        emptyTitle.isHidden = true
    }
    
    // MARK: Note check
    func checkOnNotes() {
        if !presenter.groups.isEmpty {
            back.isHidden = true
            emptyTitle.isHidden = true
        } else {
            back.isHidden = false
            emptyTitle.isHidden = false
        }
    }

}
