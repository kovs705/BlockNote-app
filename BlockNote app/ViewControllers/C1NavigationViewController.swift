//
//  C1NavigationViewController.swift
//  BlockNote app
//
//  Created by Kovs on 12.01.2022.
//

import UIKit
import CoreData
import SpriteKit

class C1NavigationViewController: C1NavViewExt {
    
    // #warning("change greetingLabel with ContainerVIew for SwiftUI")
    @IBOutlet var background: UIView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var groupCollectionView: UICollectionView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var snowBackgroundScene: SKView!
//    @IBOutlet weak var dock: UIView!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        configureProgressBarView(progressBarView: progressBarView)
        configureGroupCollectionView(gCV: groupCollectionView)
        initSnowScene(snowBack: snowBackgroundScene)
        showGreeting(greetingLabel: greetingLabel)
        configureScrollView(scrollView: scrollView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC,
           let groupIndex = groupCollectionView.indexPathsForSelectedItems?.first {
            destination.groupType = self.groups[groupIndex.row] as! GroupType
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchData()
        groupCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    @IBAction func addGroup(_ sender: UIButton) {
        let alert = UIAlertController(title: "New group", message: "Enter a name for the group", preferredStyle: .alert)
        
        // save action button
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            guard let self = self else { return }
            
            guard
                let textField = alert.textFields?.first,
                let groupToSave = textField.text
            else {
                return
            }
            
            self.save(groupName: groupToSave, groupColor: "GreenAvocado", groupCollectionView: self.groupCollectionView)
            // self.groupCollection.reloadData()
        }
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        
    }
    
}

// MARK: - UICollectionView extentions
extension C1NavigationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let group = self.groups[indexPath.row]
        
        let numberOfNotes = group.value(forKey: "noteTypes") as! Set<Note>
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.groupDetail, for: indexPath as IndexPath) as! groupViewCell
        // cell.groupName.text = group.value(forKey: "groupName") as? String
        cell.setGroupName(label: group.value(forKey: Keys.gName) as? String ?? "default name")
        cell.setBackground(color: group.value(forKey: Keys.gColor) as? String ?? "GreenAvocado")
        cell.setNumber(number: numberOfNotes.count)
        cell.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - Animation
        // cell.alpha = 0
        // cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//        UIView.animate(withDuration: animationDuration) {
//            cell.alpha = 1
//            cell.transform = .identity
//          }
//
//    }
    
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
    
    // MARK: - Segue for the groupDetail
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         self.performSegue(withIdentifier: "groupDetail", sender: indexPath)
//         print("clicked")
    }
}

extension C1NavigationViewController: detail_vc_Delegate {
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
    }
}
