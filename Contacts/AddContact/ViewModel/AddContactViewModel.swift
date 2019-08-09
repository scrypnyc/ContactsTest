//
//  AddContactViewModel.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation

protocol AddContactProtocol: class {
    func reloadSection(_ indexSet: IndexSet)
    func isDoneEnabled(_ enabled: Bool)
    func dismiss()
    func openCamera()
}

class AddContactViewModel {
    
    enum CellTypes {
        case nameAndPhoto(nameAndPhotoViewModel: NameAndPhotoTableViewCellViewModel)
        case addItem(addItemViewModel: AddItemTableViewCellViewModel)
        case item(ItemViewModel: ItemTableViewCellViewModel)
        case delete
    }
    
    var tableDatasource: [[CellTypes]] = []
    weak var delegate: AddContactProtocol?
    private var contact: ContactModel
    var isDoneEnabled = false {
        didSet {
            delegate?.isDoneEnabled(isDoneEnabled)
        }
    }
    
    let isEditFlow: Bool
    var editingContact: ContactModel?

    private var databaseManager: DatabaseManager
    
    init(databaseManager: DatabaseManager) {
        contact = ContactModel()
        isEditFlow = false
        self.databaseManager = databaseManager
        setDatasourceForContact()
        setDoneEnabled()
    }
    
    init(editContact: ContactModel, databaseManager: DatabaseManager) {
        contact = editContact
        isEditFlow = true
        self.databaseManager = databaseManager
        editingContact = editContact
        setDoneEnabled()
        setDatasourceForContact()
    }
    
    private func setDoneEnabled() {
        if isEditFlow {
            isDoneEnabled = editingContact! != contact
        } else {
            isDoneEnabled = contact.isValidContact()
        }
    }
    
    private func setDatasourceForContact() {
        let firstSection = getFirstSection()
        let secondSection = getSecondSection()
        let thirdSection = getThirdSection()
        if isEditFlow {
            tableDatasource = [firstSection, secondSection, thirdSection, [.delete]]
        } else {
            tableDatasource = [firstSection, secondSection, thirdSection]
        }
    }
    
    private func getFirstSection() -> [CellTypes] {
        let nameAndPhotoViewModel = NameAndPhotoTableViewCellViewModel(indexPath: IndexPath.init(row: 0, section: 0))
        nameAndPhotoViewModel.firstName = contact.firstName
        nameAndPhotoViewModel.lastName = contact.lastName
        nameAndPhotoViewModel.company = contact.company
        nameAndPhotoViewModel.photo = contact.photo
        nameAndPhotoViewModel.delegate = self
        let nameAndPhotoCellType: CellTypes = .nameAndPhoto(nameAndPhotoViewModel: nameAndPhotoViewModel)
        let firstSection = [nameAndPhotoCellType]
        return firstSection
    }
    
    private func getSecondSection() -> [CellTypes] {
        var phoneCellTypes = contact.phone.map { phoneModel -> CellTypes in
            let index = contact.phone.firstIndex(of: phoneModel)!
            let indexPath = IndexPath.init(row: index, section: 1)
            let customContactInfoType = CustomContactInfoTypeName(name: phoneModel.phoneType)
            let itemViewModel = ItemTableViewCellViewModel(itemType: .phone, contactInfoTypeName: customContactInfoType, customNames: [], indexPath: indexPath)
            itemViewModel.delegate = self
            itemViewModel.text = phoneModel.name
            return CellTypes.item(ItemViewModel: itemViewModel)
        }
        
        let addPhoneItemViewModel: CellTypes = .addItem(addItemViewModel: AddItemTableViewCellViewModel(infoType: .phone))
        phoneCellTypes.append(addPhoneItemViewModel)
        return phoneCellTypes
    }
    
    private func getThirdSection() -> [CellTypes] {
        var emailCellTypes = contact.email.map { emailModel -> CellTypes in
            let index = contact.email.firstIndex(of: emailModel)!
            let indexPath = IndexPath.init(row: index, section: 2)
            let customContactInfoType = CustomContactInfoTypeName(name: emailModel.emailType)
            let itemViewModel = ItemTableViewCellViewModel(itemType: .email, contactInfoTypeName: customContactInfoType, customNames: [], indexPath: indexPath)
            itemViewModel.text = emailModel.email
            itemViewModel.delegate = self
            return CellTypes.item(ItemViewModel: itemViewModel)
        }
        
        let addEmailItemViewModel: CellTypes = .addItem(addItemViewModel: AddItemTableViewCellViewModel(infoType: .email))
        emailCellTypes.append(addEmailItemViewModel)
        return emailCellTypes
    }
    
    internal func selectedModelAtIndexPath(_ indexPath: IndexPath) {
        let model = tableDatasource[indexPath.section][indexPath.row]
        switch model {
        case let .addItem(addItemViewModel: addItemViewModel):
            addItemModelSelected(addItemViewModel, indexPath: indexPath)
        case .delete:
            databaseManager.deleteContact(editingContact!.dbModel!)
            delegate?.dismiss()
        default:
            break
        }
    }
    
    private func addItemModelSelected(_ addItemViewModel: AddItemTableViewCellViewModel, indexPath: IndexPath) {
        let section = indexPath.section
        switch addItemViewModel.infoType {
        case .phone:
            let defaultPhoneType: PhoneTypes = .mobile
            let cellType = getItemCellTypeFor(itemType: .phone, contactInfoTypeName: defaultPhoneType, customNames: [], indexPath: indexPath)
            addCellType(cellType, inSection: section)
            insertPhoneTypeToContactModel(phoneType: defaultPhoneType)
        case .email:
            let defaultEmailType: EmailTypes = .work
            let cellType = getItemCellTypeFor(itemType: .email, contactInfoTypeName: defaultEmailType, customNames: [], indexPath: indexPath)
            addCellType(cellType, inSection: section)
            insertEmailTypeToContactModel(emailType: defaultEmailType)
        }
//        print(contact)
        reloadSection(section)
    }
    
    private func addCellType(_ cellType: CellTypes, inSection section: Int) {
        var datasourceArray = tableDatasource[section]
        datasourceArray.insert(cellType, at: 0)
        tableDatasource[section] = datasourceArray
    }
    
    private func getItemCellTypeFor(itemType: ContactInfoType,
                                    contactInfoTypeName: ContactInfoTypeNameProtocol,
                                    customNames: [CustomContactInfoTypeName],
                                    indexPath: IndexPath) -> CellTypes {
        let itemViewModel = ItemTableViewCellViewModel(itemType: itemType, contactInfoTypeName: contactInfoTypeName, customNames: customNames, indexPath: indexPath)
        itemViewModel.delegate = self
        let cellType = CellTypes.item(ItemViewModel: itemViewModel)
        return cellType
    }
    
    private func insertPhoneTypeToContactModel(phoneType: PhoneTypes) {
        let phone = PhoneModel(name: nil, phoneType: phoneType.name)
        contact.phone.insert(phone, at: 0)
    }
    
    private func insertEmailTypeToContactModel(emailType: EmailTypes) {
        let email = EmailModel(email: nil, emailType: emailType.name)
        contact.email.insert(email, at: 0)
    }
    
    internal func deleteRowAtIndexPath(_ indexPath: IndexPath) {
        deleteContactModelInfoTypeAtIndexPath(indexPath)
        removeCellTypeAtIndexPath(indexPath)
        setDoneEnabled()
        reloadSection(indexPath.section)
        print(contact)
    }
    
    private func deleteContactModelInfoTypeAtIndexPath(_ indexPath: IndexPath) {
        let model = tableDatasource[indexPath.section][indexPath.row]
        switch model {
        case let .item(ItemViewModel: itemViewModel):
            switch itemViewModel.itemType {
            case .email:
                contact.email.remove(at: indexPath.row)
            case .phone:
                contact.phone.remove(at: indexPath.row)
            }
        default:
            break
        }
        setDoneEnabled()
    }
    
    private func removeCellTypeAtIndexPath(_ indexPath: IndexPath) {
        var datasourceArray = tableDatasource[indexPath.section]
        datasourceArray.remove(at: indexPath.row)
        tableDatasource[indexPath.section] = datasourceArray
    }
    
    private func reloadSection(_ section: Int) {
        let indexSet = IndexSet.init(integer: section)
        delegate?.reloadSection(indexSet)
    }
    
    internal func cancelAction() {
        delegate?.dismiss()
    }
    
    internal func doneAction() {
        if isEditFlow {
            if contact.isValidContact() {
                databaseManager.updateContact(contact, contactMO: editingContact!.dbModel!)
            } else {
                databaseManager.deleteContact(editingContact!.dbModel!)
            }
        } else {
            databaseManager.saveContact(contact)
        }
        delegate?.dismiss()
    }
    
    internal func imageSelected(_ image: Data) {
        contact.photo = image
        let firstSection = getFirstSection()
        tableDatasource.remove(at: 0)
        tableDatasource.insert(firstSection, at: 0)
        reloadSection(0)
        setDoneEnabled()
    }
    
}

extension AddContactViewModel: ItemCellProtocol {
    
    func updateItemText(_ text: String, position: IndexPath) {
        let model = tableDatasource[position.section][position.row]
        switch model {
        case let .item(ItemViewModel: itemViewModel):
            switch itemViewModel.itemType {
            case .phone:
                var phoneModel = contact.phone[position.row]
                phoneModel.name = text.isEmpty ? nil : text
                contact.phone[position.row] = phoneModel
            case .email:
                var emailModel = contact.email[position.row]
                emailModel.email = text.isEmpty ? nil : text
                contact.email[position.row] = emailModel
            }
            setDoneEnabled()
        default:
            return
        }
        print(contact)
        // TODO:- Create database object
    }
    
}

extension AddContactViewModel: NameAndPhotoCellProtocol {
    
    func firstNameUpdated(_ text: String, position: IndexPath) {
        contact.firstName = text.isEmpty ? nil : text
        setDoneEnabled()
        print(contact)
    }
    
    func lastNameUpdated(_ text: String, position: IndexPath) {
        contact.lastName = text.isEmpty ? nil : text
        setDoneEnabled()
        print(contact)
    }
    
    func companyUpdated(_ text: String, position: IndexPath) {
        contact.company = text.isEmpty ? nil : text
        setDoneEnabled()
        print(contact)
    }
    
    func addPhotoAction() {
        delegate?.openCamera()
    }
    
}
