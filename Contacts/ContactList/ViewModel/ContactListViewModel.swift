//
//  ContactListViewModel.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation

protocol ContactListProtocol: class {
    func openAddContactScreen()
    func openEditContactScreen(_ contact: ContactModel)
    func reloadData()
}


class ContactListViewModel {
    
    var databaseManager: DatabaseManager
    
    weak var delegate: ContactListProtocol?
    
    var contactDictionary: [String: [ContactModel]] = [:]
    var sectionTitles: [String] = []
    
    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
    }
    
    
    private func fetchContacts() {
        do {
            let contacts = try databaseManager.fetchContacts()
            contactDictionary = [:]
            contacts.forEach({ (contactModel) in
                let letters = CharacterSet.letters
                let firstCharacter = contactModel.fullName.first!
                var firstCharacterString = ""
                if letters.contains(firstCharacter.unicodeScalars.first!) {
                    firstCharacterString = String(contactModel.fullName.first!)
                } else {
                    firstCharacterString = "#"
                }
                
                if var existingSectionContacts = contactDictionary[firstCharacterString] {
                    existingSectionContacts.append(contactModel)
                    contactDictionary[firstCharacterString] = existingSectionContacts
                } else {
                    contactDictionary[firstCharacterString] = [contactModel]
                }
                
            })
            
            
            sectionTitles = contactDictionary.keys.sorted()
        } catch let error {
            print("Error in fetching contacts: \(error)")
        }
    }
    
    
    internal func viewWillAppear() {
        fetchContacts()
        delegate?.reloadData()
    }
    
    
    internal func rowSelectedAtIndexPath(_ indexPath: IndexPath) {
        let sectionKey = sectionTitles[indexPath.section]
        if let contacts = contactDictionary[sectionKey] {
            let contact = contacts[indexPath.row]
            delegate?.openEditContactScreen(contact)
        }
    }
    
    
    @objc internal func plusBarButtonAction() {
        delegate?.openAddContactScreen()
    }
}
