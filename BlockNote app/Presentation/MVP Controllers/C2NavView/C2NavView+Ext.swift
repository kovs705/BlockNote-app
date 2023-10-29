//
//  C2NavView+Ext.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 29.10.2023.
//

import UIKit
import SpriteKit

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
        navigationController?.pushViewController(vc, animated: true)
    }

    func showGreeting(with text: String) {
        greetingLabel.text = text
    }
}

// MARK: - ScrollView extension
extension C2NavViewControllerVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            thinStatusBar.alpha = scrollView.contentOffset.y >= 1 ? 1.0 : 0.0
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
        presenter.openGroup(group: groupType as! GroupType)
        presenter.saveChanges()
        
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
