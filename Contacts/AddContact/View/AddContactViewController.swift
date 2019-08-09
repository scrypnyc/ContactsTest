//
//  AddContactViewController.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import UIKit

class AddContactViewController: UITableViewController {
    
    var viewModel: AddContactViewModel
    
    init(viewModel: AddContactViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
        viewModel.delegate = self
        title = "New Contact"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerTableViewClasses()
        setTableViewProperties()
        addRightBarDoneItem()
        addLeftBarCancelItem()
    }
    
    private func registerTableViewClasses() {
        tableView.register(NameAndPhotoTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(AddItemTableViewCell.self, forCellReuseIdentifier: "Cell2")
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "Cell3")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeleteCell")
    }
    
    private func setTableViewProperties() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.setEditing(true, animated: true)
        tableView.allowsSelectionDuringEditing = true
    }
    
    private func addRightBarDoneItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.isDoneEnabled
    }
    
    private func addLeftBarCancelItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction))
    }
    
    @objc private func doneButtonAction() {
        viewModel.doneAction()
    }
    
    @objc private func cancelButtonAction() {
        viewModel.cancelAction()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableDatasource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableDatasource[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.tableDatasource[indexPath.section][indexPath.row]
        switch cellType {
        case let .nameAndPhoto(nameAndPhotoViewModel: cellViewModel):
            return getNameAndPhotoCellFor(indexPath: indexPath, viewModel: cellViewModel)
        case let .addItem(addItemViewModel: cellViewModel):
            return getAddItemCellFor(indexPath: indexPath, viewModel: cellViewModel)
        case let .item(ItemViewModel: cellViewModel):
            return getItemCellFor(indexPath: indexPath, viewModel: cellViewModel)
        case .delete:
            return getDeleteTableViewCell(indexPath: indexPath)
        }
    }
    
    private func getNameAndPhotoCellFor(indexPath: IndexPath, viewModel: NameAndPhotoTableViewCellViewModel) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NameAndPhotoTableViewCell
        
        if cell == nil {
            cell = NameAndPhotoTableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        // Configure the cell...
        cell?.selectionStyle = .none
        cell?.configureCell(viewModel: viewModel)
        return cell!
    }
    
    private func getAddItemCellFor(indexPath: IndexPath, viewModel: AddItemTableViewCellViewModel) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as? AddItemTableViewCell
        
        if cell == nil {
            cell = AddItemTableViewCell(style: .default, reuseIdentifier: "Cell2")
        }
        
        // Configure the cell...
        
        cell?.configureCell(viewModel: viewModel)
        return cell!
    }
    
    private func getItemCellFor(indexPath: IndexPath, viewModel: ItemTableViewCellViewModel) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as? ItemTableViewCell
        
        if cell == nil {
            cell = ItemTableViewCell(style: .default, reuseIdentifier: "Cell3")
        }
        
        // Configure the cell...
        viewModel.position = indexPath
        cell?.configureCell(viewModel: viewModel)
        return cell!
    }
    
    private func getDeleteTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteCell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = "Delete contact"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .red
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectedModelAtIndexPath(indexPath)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return  true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let model = viewModel.tableDatasource[indexPath.section][indexPath.row]
        switch model {
        case .item:
            return .delete
        case .addItem:
            return .insert
        case .nameAndPhoto, .delete:
            return .none
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            viewModel.deleteRowAtIndexPath(indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.tableView(tableView, didSelectRowAt: indexPath)
        }
    }

}

extension AddContactViewController: AddContactProtocol {
    
    func reloadSection(_ indexSet: IndexSet) {
        tableView.reloadSections(indexSet, with: .middle)
    }
    
    func isDoneEnabled(_ enabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            navigationController?.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
}

extension AddContactViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        viewModel.imageSelected(imageData)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddContactViewController: UINavigationControllerDelegate {
    

}
