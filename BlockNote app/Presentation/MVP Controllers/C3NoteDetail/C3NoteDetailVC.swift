//
//  C3NoteDetailVC.swift
//  BlockNote app
//
//  Created by Kovs on 15.07.2023.
//

import UIKit
import SwiftUI

class C3NoteDetailVC: UIViewController {

    // MARK: - Properties
    var deletingBlocksOrder: Int = 0

    var imagePicker: UIImagePickerController!

    var textForTextlock: String = ""
    
    var keyboardIsOpened = false

    var addBlockButton = dockButton(fontSize: 20, icon: Icons.addGroup, color: .systemGray4)
    let textDockButton = dockTextButton(frame: .zero)
    var thinStatusBar = UIVisualEffectView()
    let heightForStatusBar: CGFloat = 55

    @IBOutlet weak var noteListTB: UITableView!
    let notificationCenter = NotificationCenter.default

    var presenter: C3NoteDetailPresenterProtocol!

    // MARK: - UI properties
    let padding: CGFloat = 10

    lazy var contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .horizontal
        contentView.distribution = .fill
        contentView.spacing = 10
        contentView.backgroundColor = .systemGray6

        return contentView
    }()

    lazy var dock: UIView = {
       let dock = UIView()
        dock.backgroundColor = .systemGray6
        dock.translatesAutoresizingMaskIntoConstraints = false
        return dock
    }()

    lazy var backbutton: UIButton = {
       let backButton = UIButton()
        backButton.cornerRadius = 15
        backButton.backgroundColor = .systemGray6
        backButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIHelper.giveConfigForImage(size: 18, weight: .medium)), for: .normal)

        return backButton
    }()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        presenter.sortAndUpdate()
        configureTableView()

        title = presenter.note?.wrappedNoteName
        configureDockButtons()

        let addBlockButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBlock))
        self.navigationItem.rightBarButtonItem = addBlockButton

         notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
         notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        configureDock()
        configureBackButton()
        configureStatusBar()

        noteListTB.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 160, right: 0)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tapGesture.cancelsTouchesInView = false
            noteListTB.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.backbutton.layer.opacity = 1
        }
    }
    
    // MARK: - UI funcs
    func configureTableView() {
        noteListTB.delegate = self
        noteListTB.dataSource = self
        noteListTB.dragDelegate = self
        noteListTB.dragInteractionEnabled = true
        noteListTB.sectionHeaderHeight = 100
        // noteListTB.register(UINib(nibName: "NewPhotoBlock", bundle: nil), forCellReuseIdentifier: NewPhotoBlock.newPhotoBlockID)
    }

    func configureStatusBar() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        view.addSubviews(thinStatusBar)
        thinStatusBar.backgroundColor = .clear
        thinStatusBar.effect = blurEffect

        thinStatusBar.snp.makeConstraints { make in
            make.height.equalTo(heightForStatusBar)
            make.width.equalTo(view.snp.width)
            make.top.equalTo(view)
        }
    }
    
    func configureDockButtons() {
        addBlockButton.addTarget(self, action: #selector(addBlock), for: .touchUpInside)
        textDockButton.addTarget(self, action: #selector(createTextBlock), for: .touchUpInside)
    }

    func configureDock() {
        view.addSubviews(dock)

        NSLayoutConstraint.activate([
            dock.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dock.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dock.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            dock.widthAnchor.constraint(equalToConstant: view.bounds.width),
            dock.heightAnchor.constraint(equalToConstant: 80)

        ])

        // placing contentView - UIStackView
        dock.addSubviews(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: dock.topAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: dock.leadingAnchor, constant: padding * 2),
            contentView.trailingAnchor.constraint(equalTo: dock.trailingAnchor, constant: -(padding * 2)),
            contentView.heightAnchor.constraint(equalToConstant: 40)
        ])

        // placing text buttons:
        contentView.addArrangedSubview(addBlockButton)
        contentView.addArrangedSubview(textDockButton)
    }

    func configureBackButton() {
        view.addSubviews(backbutton)

        NSLayoutConstraint.activate([
            backbutton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backbutton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backbutton.heightAnchor.constraint(equalToConstant: 35),
            backbutton.widthAnchor.constraint(equalToConstant: 35)
        ])

        backbutton.addTarget(self, action: #selector(dismissIt), for: .touchUpInside)
    }

    // MARK: - Objc funcs
    @objc func dismissIt() {
        dismiss(animated: true)
    }

    @objc func handleTap(_ gRecognizer: UITapGestureRecognizer) {
        let tapLocation = gRecognizer.location(in: noteListTB)
        if noteListTB.indexPathForRow(at: tapLocation) == nil {
            // TODO: - Outside of the cell
            if presenter.indexOfBlock != 0 {
                let index = IndexPath(row: presenter.indexOfBlock - 1, section: 0)
                guard let textBlockCell = noteListTB.cellForRow(at: index) as? TVTextBlock else {
                    guard let titleBlockCell = noteListTB.cellForRow(at: index) as? TVTitleBlock else {
                        return
                    }
                    titleBlockCell.textView.resignFirstResponder()
                    return
                }
                textBlockCell.textView.resignFirstResponder()
            }
            presenter.indexOfBlock = 0
        }
    }

    // MARK: - Keyboard adjuster
    @objc func adjustForKeyboard(notification: Notification) {

        if notification.name == UIResponder.keyboardWillHideNotification {
            keyboardIsOpened = false
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35, delay: 0, animations: { [weak self] in
                    guard let self = self else { return }
                    self.noteListTB.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 160, right: 0)
                })
            }

        } else {
            keyboardIsOpened = true
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35, delay: 0, animations: { [weak self] in
                    guard let self = self else { return }
                    self.noteListTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: notification.keyboardHeight + self.view.safeAreaInsets.bottom, right: 0)
                })
            }

        }

        noteListTB.scrollIndicatorInsets = noteListTB.contentInset
    }

    // MARK: - create text block and start typing in the new block
    @objc func createTextBlock() {
        presenter.createBlock()
        
        noteListTB.beginUpdates()
            if presenter.noteItemArray_sorted.isEmpty {
                presenter.save(blockType: Block.titleBlock, theCase: .title, pickedImage: nil, at: presenter.indexOfBlock)
            } else {
                presenter.save(blockType: Block.textBlock, theCase: .text, pickedImage: nil, at: presenter.indexOfBlock)
            }
        
        noteListTB.endUpdates()
        
        startTyping(from: presenter.indexOfBlock - 1)
    }
    
    // MARK: - Add block
    @objc func addBlock() {
        let alert = UIAlertController(title: "New block", message: "Choose your block", preferredStyle: .actionSheet)
        
        let saveTitleBlock = UIAlertAction(title: "Header", style: .default) { [weak self] _ in
            guard let self = self else { return }
            presenter.createBlock()
            self.presenter.save(blockType: Block.titleBlock, theCase: .title, pickedImage: nil, at: presenter.indexOfBlock)
        }

        let saveTextBlock = UIAlertAction(title: "Text", style: .default) { [weak self] _ in
            guard let self = self else { return }
            presenter.createBlock()
            self.presenter.save(blockType: Block.textBlock, theCase: .text, pickedImage: nil, at: presenter.indexOfBlock)
        }

        let saveSpaceBlock = UIAlertAction(title: "Spacer", style: .default) { [weak self] _ in
            guard let self = self else { return }
            presenter.createBlock()
            self.presenter.save(blockType: Block.spaceBlock, theCase: .space, pickedImage: nil, at: presenter.indexOfBlock)
        }

        // photoBlock save
        let savePhotoBlock = UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.showPhotoPicker()
        }

        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        // alert.addTextField()
        alert.addAction(saveTitleBlock)
        alert.addAction(saveTextBlock)
        alert.addAction(savePhotoBlock)
        alert.addAction(saveSpaceBlock)
        alert.addAction(cancelAction)

        present(alert, animated: true)

    }

    @objc func showPhotoPicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true)
    }

}
