//
//  C3NoteDetailTV+Ext.swift
//  BlockNote app
//
//  Created by Eugene Kovs on 29.10.2023.
//

import UIKit

extension C3NoteDetailVC: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let noteItem = presenter.noteItemArray_sorted[indexPath.row]

        if noteItem.value(forKey: Keys.niType) as! String == Block.textBlock {
            return presenter.noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width - 40, font: UIFont.systemFont(ofSize: 17))

        } else if noteItem.value(forKey: Keys.niType) as! String == Block.titleBlock {
            return presenter.noteItemArray_sorted[indexPath.row].noteItemText
                .heightWithConstrainedWidth(width: tableView.frame.width - 40, font: UIFont.systemFont(ofSize: 22, weight: .bold))

        } else if noteItem.value(forKey: Keys.niType) as! String == Block.photoBlock {
            let image = UIImage(data: noteItem.noteItemPhoto!)
            let imageCrop = image!.getCropRatio()
            return tableView.frame.width / imageCrop
        } else {
            return 30
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.noteItemArray_sorted.count
    }

    // MARK: - Drag&Drop UITableView
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = presenter.noteItemArray_sorted[indexPath.row]
        return [dragItem]
    }

    // MARK: - Move row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let mover = presenter.noteItemArray_sorted.remove(at: sourceIndexPath.row)
        presenter.noteItemArray_sorted.insert(mover, at: destinationIndexPath.row)

        for block in self.presenter.noteItemArray_sorted {
            let blockIndex = block.noteItemOrder - 1
            print(blockIndex)
            // from top to bottom:
            if sourceIndexPath.row > destinationIndexPath.row {
                if !(blockIndex < destinationIndexPath.row) {
                    if blockIndex <= sourceIndexPath.row {
                        block.setValue(block.noteItemOrder + 1, forKey: Keys.niOrder)
                    }
                }
            } else {
                // from bottom to top:
                if blockIndex > sourceIndexPath.row {
                    if blockIndex <= destinationIndexPath.row {
                        block.setValue(block.noteItemOrder - 1, forKey: Keys.niOrder)
                    }
                }
            }

        }
        mover.setValue(destinationIndexPath.row + 1, forKey: Keys.niOrder)

        presenter.delegateSave()
    }

    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteItem = presenter.noteItemArray_sorted[indexPath.row]

        guard let type = noteItem.value(forKey: Keys.niType) as? String else {
            return UITableViewCell()
        }

        switch type {
        case Block.textBlock:
            return configureTextBlockCell(for: noteItem, in: tableView, at: indexPath)
        case Block.titleBlock:
            return configureTitleBlockCell(for: noteItem, in: tableView, at: indexPath)
        case Block.photoBlock:
            return configurePhotoBlockCell(for: noteItem, in: tableView, at: indexPath)
        case Block.spaceBlock:
            return configureSpaceBlockCell(for: noteItem, in: tableView, at: indexPath)
        default:
            return defaultCell()
        }
    }
    
    // MARK: - Default cell
    func defaultCell() -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - TextBlock
    func configureTextBlockCell(for noteItem: NoteItem, in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Block.textBlock, for: indexPath) as? TVTextBlock else {
            return defaultCell()
        }

        cell.loadText(for: noteItem) { [weak tableView] string in
            UIView.performWithoutAnimation {
                tableView?.performBatchUpdates({
                    cell.textView.text = string
                    cell.label.text = string
                })
            }
        }
        
        cell.beginEditing = { [weak self] in
            guard let self = self else { return }
            presenter.indexOfBlock = indexPath.row + 1
        }

        cell.textChanged { [weak self, weak tableView] (newText: String) in
            guard let self = self else { return }
            noteItem.noteItemText = newText
            presenter.indexOfBlock = indexPath.row
            
            UIView.performWithoutAnimation {
                tableView?.performBatchUpdates({
                    cell.label.text = newText
                    self.presenter.getText(text: newText, noteListTB: self.noteListTB)
                })
            }
        }
        
        return cell
    }
    
    func configureTitleBlockCell(for noteItem: NoteItem, in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Block.titleBlock, for: indexPath) as? TVTitleBlock else {
            return defaultCell()
        }

        cell.loadText(for: noteItem) { [weak tableView] string in
            tableView?.performBatchUpdates({
                cell.textView.text = string
                cell.label.text = string
            })
        }
        
        cell.beginEditing = { [weak self] in
            guard let self = self else { return }
            presenter.indexOfBlock = indexPath.row + 1
        }

        cell.textChanged { [weak self, weak tableView] (newText: String) in
            guard let self = self else { return }
            noteItem.noteItemText = newText
            presenter.indexOfBlock = indexPath.row
            
            tableView?.performBatchUpdates({
                cell.label.text = newText
                self.presenter.getText(text: newText, noteListTB: self.noteListTB)
            })
        }

        return cell
    }
    
    func configureSpaceBlockCell(for noteItem: NoteItem, in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Block.spaceBlock, for: indexPath) as? TVSpaceBlock else {
            return defaultCell()
        }
        
        return cell
    }
    
    func configurePhotoBlockCell(for noteItem: NoteItem, in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Block.photoBlock, for: indexPath) as? TVPhotoBlock else {
            return defaultCell()
        }

        cell.downloadImage(for: noteItem) { [weak tableView] image in
            tableView?.performBatchUpdates({
                cell.imageBlock.image = image
            })
        }

        // width 330, height 270
        cell.imageBlock.frame = CGRect(x: 0, y: 0, width: 330, height: 300)
        cell.frame = CGRect(x: 0, y: 0, width: 330, height: 300)

        return cell
    }

    // MARK: - Delete block
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteblock(noteListTB: noteListTB, at: indexPath)
        }
    }
}
