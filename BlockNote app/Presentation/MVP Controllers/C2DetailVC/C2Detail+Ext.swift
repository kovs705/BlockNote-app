//
//  C2Detail+Ext.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 29.10.2023.
//

import UIKit

// MARK: - UICollectinView extensions
extension C2DetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.noteArraySorted.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let noteCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.noteViewCell, for: indexPath) as! NoteViewCell

        noteCell.setNoteName(name: presenter.noteArraySorted[indexPath.row].value(forKey: Keys.nName) as! String)
        noteCell.contentView.translatesAutoresizingMaskIntoConstraints = false

        return noteCell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 4) / 1, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let note = presenter.noteArraySorted[indexPath.row]

        defer {
            collectionView.isUserInteractionEnabled = true
        }

        pushToNoteDetail(using: note)
        collectionView.isUserInteractionEnabled = false
    }

    func pushToNoteDetail(using note: Note) {
        let coordinator = Builder()
        let vc = coordinator.getC3NoteDetailVC(note: note)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen // fullscreen?
        present(vc, animated: true)
    }

    //    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    //        collectionView.reloadItems(at: [indexPath])
    //        collectionView.deselectItem(at: indexPath, animated: true)
    //    }
}

// MARK: - Protocol
extension C2DetailVC: C2DetailViewProtocol {

    func popVC() {
        _ = navigationController?.popViewController(animated: true)
    }

    func performBatchUpdates() {
        noteListCollection.performBatchUpdates({
            noteListCollection.insertItems(at: [IndexPath(item: presenter.noteArraySorted.count - 1, section: 0)])
        }, completion: nil)
    }

    func presentAlert(_ alert: UIAlertController, animated: Bool) {
        present(alert, animated: animated)
    }

    func pushToAgenda(using groupType: GroupType) {
        let coordinator = Builder()
        let vc = coordinator.getAgendaVC(group: groupType)
        vc.modalPresentationStyle = .popover

        let uinav = UINavigationController(rootViewController: self)
        uinav.pushViewController(vc, animated: true)
    }

    func performTransition(to vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }

}
