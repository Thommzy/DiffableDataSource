//
//  ViewController.swift
//  TimDiffableDataSource
//
//  Created by Obeisun Timothy on 01/02/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    var dataSource: UITableViewDiffableDataSource<Section, Fruit>!
    var fruits: [Fruit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupDataSource()
        setupNavBar()
    }
    
    private func setupNavBar(){
        title = "My Fruits"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapAdd))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = itemIdentifier.title
            return cell
        })
    }
    
    @objc func didTapAdd() {
        let actionSheet = UIAlertController(title: "Select Fruit", message: nil, preferredStyle: .actionSheet)
        
        for x in 0...100 {
            actionSheet.addAction(UIAlertAction(title: "Fruit \(x + 1)", style: .default, handler: { [weak self] _ in
                let fruit = Fruit(title: "Fruit \(x + 1) ")
                self?.fruits.append(fruit)
                self?.updateDataSource()
                
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Fruit>()
        snapshot.appendSections([.first])
        snapshot.appendItems(fruits)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let fruit = dataSource.itemIdentifier(for: indexPath) else {return}
        print(fruit.title)
    }
}

