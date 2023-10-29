//
//  C2DetailVC.swift
//  BlockNote app
//
//  Created by Kovs on 08.07.2023.
//

import UIKit
import SwiftUI

protocol detail_vc_Delegate {
    func deleteAndUpdate()
    func closeAndDelete()
}

class C2DetailVC: UIViewController {
    // main:
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet weak var noteListCollection: UICollectionView!
    // design and color:
        @IBOutlet weak var topBar: UIView!
        @IBOutlet weak var first_column: UIStackView!
        @IBOutlet weak var second_column: UIStackView!
        @IBOutlet weak var third_column: UIStackView!

    // numbers and notes:
        @IBOutlet weak var numberOfNotesLabel: UILabel!
        @IBOutlet weak var importantNotesLabel: UILabel!

    var presenter: C2DetailPresenterProtocol!
    var delegate: detail_vc_Delegate?

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.groupType.groupName

        presenter.sortArray()

        setupDetailVC(scrollView: scrollView, noteListCollection: noteListCollection, numberOfNotesLabel: numberOfNotesLabel, topBar: topBar, first_column: first_column, second_column: second_column, third_column: third_column)

    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        noteListCollection.reloadData()
    }

    // MARK: - Objc funcs
    @IBAction func pushToAgenda(_ sender: UIBarButtonItem) {
        presenter.performTransitionToAgendaVC(groupType: presenter.groupType)
    }

    // MARK: - IBActions
    @IBAction func addNoteButton(sender: UIButton) {
        presenter.addNote()
    }

    @IBAction func deleteGroup(_ sender: UIButton) {
        presenter.ask()
    }

    // MARK: - UI configuration
    private func setupDetailVC(scrollView: UIScrollView, noteListCollection: UICollectionView, numberOfNotesLabel: UILabel, topBar: UIView, first_column: UIStackView, second_column: UIStackView, third_column: UIStackView) {
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true

        // noteListCollection.backgroundColor = UIColor(named: "BackWhite")
        noteListCollection.register(UINib(nibName: "NoteViewCell", bundle: nil), forCellWithReuseIdentifier: "NoteViewCell")
        noteListCollection.allowsSelection = true
        noteListCollection.allowsMultipleSelection = true

        numberOfNotesLabel.text = "\(presenter.groupType.typesOfNoteArray.count)"

        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.masksToBounds = false

        topBar.layer.cornerRadius = 20
        topBar.shadowOffset = CGSize(width: 5, height: 0)
        topBar.layer.shadowRadius = 10
        topBar.shadowOpacity = 0.3
        topBar.layer.shadowPath = CGPath(rect: topBar.bounds, transform: nil)

        topBar.backgroundColor = UIColor(named: "\(presenter.groupType.groupColor ?? GroupColor.blueBerry.rawValue)")

        first_column.backgroundColor = UIColor(named: "\(presenter.groupType.groupColor ?? GroupColor.blueBerry.rawValue)")
        second_column.backgroundColor = UIColor(named: "\(presenter.groupType.groupColor ?? GroupColor.blueBerry.rawValue)")
        third_column.backgroundColor = UIColor(named: "\(presenter.groupType.groupColor ?? GroupColor.blueBerry.rawValue)")
    }

}
