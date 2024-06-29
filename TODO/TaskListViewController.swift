//
//  TaskListViewController.swift
//  TODO
//
//  Created by Kawai, Tomotaka | Monta | TMO on 2024/06/22.
//

import Foundation
import UIKit

final class TaskListViewController: UIViewController {
    enum Section {
        case main
    }
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Task.ID>!

    var viewModel = TaskListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureDataSource()
        initData()
    }

    // MARK: Initial Data setting
    func initData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Task.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.taskIds, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func configureLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)

        // trailingSwipeActionConfigurationProvider -> (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?
        configuration.trailingSwipeActionsConfigurationProvider = {indexPath in self.makeDeleteGesture(indexPath: indexPath)}
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(frame: .null, collectionViewLayout: layout)

        view.addSubview(collectionView)
        // Maybe allow view to set constraints in codebase by setting translatesAutoresizingMaskIntoConstraints as false.
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Task> { (cell, index, task) in
            var content = cell.defaultContentConfiguration()
            content.text = task.getTaskName()
            cell.contentConfiguration = content
            cell.accessories = [
                .checkmark(displayed: .always, options: .init(isHidden: !task.getIsDone()))
            ]
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {[weak self] collectionView, indexPath, id in
            let task = self?.viewModel.getTaskById(id: id)
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
    }

    // MARK: - create gesture
    private func makeDeleteGesture(indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {  [weak self] action, view, _ in
            guard let targetTaskId = self?.dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            self?.viewModel.removeTaskById(id: targetTaskId)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
