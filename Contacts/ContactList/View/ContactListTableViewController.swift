//
//  ContactListTableViewController.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    private var viewModel: ContactListViewModel
    
    init(viewModel: ContactListViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
        title = "Contacts"
        viewModel.delegate = self
        addPlusBarItem()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    
    private func addPlusBarItem() {
        let plusBarITem = UIBarButtonItem(barButtonSystemItem: .add, target: viewModel, action: #selector(viewModel.plusBarButtonAction))
        navigationItem.rightBarButtonItem = plusBarITem
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = viewModel.sectionTitles[section]
        if let sectionContacts = viewModel.contactDictionary[sectionKey] {
            return sectionContacts.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let sectionKey = viewModel.sectionTitles[indexPath.section]
        if let sectionContacts = viewModel.contactDictionary[sectionKey] {
            cell.textLabel?.text = sectionContacts[indexPath.row].fullName
        }
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.rowSelectedAtIndexPath(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionKey = viewModel.sectionTitles[section]
        return sectionKey.uppercased()
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionTitles
    }
}


extension ContactListTableViewController: ContactListProtocol {
    
    func openEditContactScreen(_ contact: ContactModel) {
        let addContactViewModel = AddContactViewModel(editContact: contact, databaseManager: viewModel.databaseManager)
        openAddContactScreen(addContactViewModel: addContactViewModel)
    }
    
    
    func openAddContactScreen() {
        let addContactViewModel = AddContactViewModel(databaseManager: viewModel.databaseManager)
        openAddContactScreen(addContactViewModel: addContactViewModel)
    }
    
    
    func reloadData() {
        tableView.reloadData()
    }
    
    
    private func openAddContactScreen(addContactViewModel: AddContactViewModel) {
        let addContactVC = AddContactViewController(viewModel: addContactViewModel)
        let navigationController = UINavigationController(rootViewController: addContactVC)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
}
