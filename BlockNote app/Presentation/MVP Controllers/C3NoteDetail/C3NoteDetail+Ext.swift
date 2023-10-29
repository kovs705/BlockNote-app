//
//  C3NoteDetail+Ext.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 29.10.2023.
//

import UIKit

// MARK: - Presenter protocol
extension C3NoteDetailVC: C3NoteDetailViewProtocol {

    func beginEndUpdates() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.noteListTB.beginUpdates()
            self.noteListTB.endUpdates()
        }
    }

    func performBatchUpdates(at insertRow: Int) {
        noteListTB.performBatchUpdates({
            noteListTB.insertRows(at: [IndexPath(row: insertRow, section: 0)], with: .automatic)
        }, completion: nil)
    }

    func performDeleteUpdates(at deleteRow: Int) {
        noteListTB.performBatchUpdates({
            noteListTB.deleteRows(at: [IndexPath(row: deleteRow - 1, section: 0)], with: .automatic)
        }, completion: nil)
    }
    
    func startTyping(from row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        let cell = noteListTB.cellForRow(at: indexPath) as? TVTextBlock
        cell?.textView.becomeFirstResponder()
    }

}

// MARK: - ImagePicker
// TODO: Гав, make a cell with up to 3-4 photos with a fixed size
extension C3NoteDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("closed")
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let pickedImage = info[.originalImage] as? UIImage else {
            return
        }

        presenter.createBlock()
        presenter.save(blockType: Block.photoBlock, theCase: .photo, pickedImage: pickedImage, at: presenter.noteItemArray_sorted.count)

        picker.dismiss(animated: true)

    }

}

// MARK: - UIScrollView Delegate
extension C3NoteDetailVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.backbutton.layer.opacity = 1
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.backbutton.layer.opacity = 0

            }
        }
        
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
