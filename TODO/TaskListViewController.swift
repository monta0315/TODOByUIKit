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
        case done
        case unDone
    }
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Task.ID>!

    var viewModel = TaskListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        applySnapShot()
    }

    // MARK: Initial Data setting
    func applySnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Task.ID>()
        snapshot.appendSections([.unDone, .done])
        snapshot.appendItems(viewModel.unDoneTaskIds, toSection: .unDone)
        snapshot.appendItems(viewModel.doneTaskIds, toSection: .done)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func configureCollectionView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)

        // trailingSwipeActionConfigurationProvider -> (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?
        configuration.trailingSwipeActionsConfigurationProvider = {indexPath in self.makeDeleteGesture(indexPath: indexPath)}
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(frame: .null, collectionViewLayout: layout)

        view.addSubview(collectionView)
        // Maybe allow view to set constraints in codebase by setting translatesAutoresizingMaskIntoConstraints as false.
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        collectionView.delegate = self
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
        registerHeader()
    }

    private func registerHeader() {
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { view, _, indexPath in
            var configuration = view.defaultContentConfiguration()
            configuration.text = indexPath.section == 0 ? "TODO" : "Done"
            view.contentConfiguration = configuration
        }

        dataSource.supplementaryViewProvider = {collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }

    // For updating Task's property changing
    private func applySnapshotByReconfiguringItem(id: UUID) {
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([id])

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - create gesture
    private func makeDeleteGesture(indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") {  [weak self] action, view, _ in
            guard let targetTaskId = self?.dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            self?.viewModel.removeTaskById(id: targetTaskId)
            // For updating TaskId changing
            self?.applySnapShot()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - CollectionView delegate
extension TaskListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let targetTaskId = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        viewModel.toggleTaskStatus(id: targetTaskId)
        applySnapshotByReconfiguringItem(id: targetTaskId)
        applySnapShot()
    }
}
