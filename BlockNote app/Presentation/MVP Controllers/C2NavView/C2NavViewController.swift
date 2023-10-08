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
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
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

        presenter.fetchData(using: SortOrder.lastChangedGroup)
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
        back.backgroundColor = UIColor(resource: .frontBack)
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

// MARK: - SpriteKit snowScene
extension C2NavViewControllerVC: SKSnowScene {

    internal func initSnowScene(snowBack: SKView) {
        let snowParticleScene = SnowScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        snowParticleScene.scaleMode = .aspectFill
        snowParticleScene.backgroundColor = .clear

        snowBack.allowsTransparency = true
        snowBack.backgroundColor = .clear

        snowBack.presentScene(snowParticleScene)
    }
}

// MARK: - Presenter methods
extension C2NavViewControllerVC: C2NavViewControllerViewProtocol {
    func updateData() {
        checkOnNotes()
        self.groupCollectionView.reloadData()
    }

    func update() {
        UIView.animate(withDuration: 0.05, delay: 0, options: [.beginFromCurrentState]) { [weak self] in
            guard let self = self else { return }
            self.groupCollectionView.reloadInputViews()
        }
    }

    func performTransition(to vc: UIViewController) {
//        present(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }

    func showGreeting(with text: String) {
        greetingLabel.text = text
    }
}

// MARK: - ScrollView extension
extension C2NavViewControllerVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 1 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.thinStatusBar.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.thinStatusBar.alpha = 0.0
            }
        }
    }
}

// MARK: - UICollectionView extentions
extension C2NavViewControllerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.groups.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let group = presenter.groups[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.groupDetail, for: indexPath as IndexPath) as! groupViewCell
        cell.setGroupCell(group: group as! GroupType)
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let group = presenter.groups[indexPath.row]

        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let menuActions = [
                UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { [weak self] _ in
                    guard let self = self else { return }
                    self.presenter.showGroupEdit(group: group as! GroupType)
                },
                UIAction(title: "Delete", image: UIImage(systemName: "trash.fill")?.withTintColor(.systemRed).withRenderingMode(.alwaysOriginal)) { [weak self] _ in
                    guard let self = self else { return }
                    self.presenter.delete(group: group as! GroupType)
                }
            ]

            let menu = UIMenu(title: "Choose operation", children: menuActions)
            return menu
        }

        return configuration
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        UIView.animate(withDuration: 0.5, delay: 0) {
            cell.alpha = 1
            cell.contentView.alpha = 1
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfGroupsPerRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfGroupsPerRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfGroupsPerRow))

        return CGSize(width: size, height: size)

        // return CGSize(width: 165, height: 165)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupType = presenter.groups[indexPath.row]

        presenter.performTransitionToDetailVC(groupType: groupType as! GroupType)
    }
}

// MARK: - Detail_vc_Delegate
extension C2NavViewControllerVC: detail_vc_Delegate {
    // place a func to update UICollectionView in rootVC just after deleting a group in detailVC:
    func deleteAndUpdate() {
        _ = navigationController?.popViewController(animated: true)
        self.groupCollectionView.reloadData()
    }
    func closeAndDelete() {
        groupCollectionView.reloadData()
    }

    func configureGroupCollectionView(gCV: UICollectionView) {
        gCV.allowsSelection = true
        gCV.dataSource      = self
        gCV.delegate        = self

        gCV.alwaysBounceVertical = true
        gCV.bounces = true
    }
}
