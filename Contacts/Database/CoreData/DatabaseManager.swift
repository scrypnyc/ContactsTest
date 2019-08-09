//
//  DatabaseManager.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {
    

    enum DB {
        case coreData
//        case realm
//        case firebase
    }
    
    private var db: DB
    var actualPersistentContainer: NSPersistentContainer!
    
    init(db: DB, isTesting: Bool = false) {
        self.db = db
        
        if isTesting {
            self.actualPersistentContainer = mockPersistantContainer
        } else {
            self.actualPersistentContainer = persistentContainer
        }
        
    }
    
    internal func saveContact(_ contact: ContactModel) {
        switch db {
        case .coreData:
            saveContactToCoreData(contact)
//        case .firebase:
//            break
//        case .realm:
//            break
        }
    }
    
    internal func updateContact(_ contact: ContactModel, contactMO: Any) {
        switch db {
        case .coreData:
            guard let contactObject = contactMO as? ContactMO else { return }
            fillCoreDataDBContact(contactObject, fromContact: contact)
            saveContext()
//        case .firebase:
//            break
//        case .realm:
//            break
        }
    }
    
    internal func deleteContact(_ contactMO: Any) {
        switch db {
        case .coreData:
            deleteContactFromCoreData(contactMO)
//        case .firebase:
//            break
//        case .realm:
//            break
        }
    }
    
    private func deleteContactFromCoreData(_ contactMO: Any) {
        guard let contact = contactMO as? ContactMO else { return }
        let managedContext = actualPersistentContainer.viewContext
        managedContext.delete(contact)
        saveContext()
    }
    
    internal func fetchContacts() throws -> [ContactModel] {
        switch db {
        case .coreData:
            do {
                return try fetchContactsFromCoreData()
            } catch {
                throw error
            }
//        case .firebase:
//            break
//        case .realm:
//            break
        }
//        return []
    }
    
    private func fetchContactsFromCoreData() throws -> [ContactModel] {
        let managedContext = actualPersistentContainer.viewContext
        let request = NSFetchRequest<ContactMO>(entityName: "Contact")
        do {
            let result = try managedContext.fetch(request)
            return result.map { contactMO in ContactModel(contactMO: contactMO) }
        } catch let error {
            throw error
        }
    }
    
    private func deleteObject(object: NSManagedObject) {
        let managedContext = actualPersistentContainer.viewContext
        managedContext.delete(object)
    }
    
    private func saveContactToCoreData(_ contact: ContactModel) {
        let managedContext = actualPersistentContainer.viewContext
        let contactEntity = NSEntityDescription.entity(forEntityName: "Contact", in: managedContext)
        let contactMO = ContactMO(entity: contactEntity!, insertInto: managedContext)
        fillCoreDataDBContact(contactMO, fromContact: contact)
        saveContext()
    }
    
    private func fillCoreDataDBContact(_ contactMO: ContactMO, fromContact contact: ContactModel) {
        contactMO.firstName = contact.firstName
        contactMO.lastName = contact.lastName
        contactMO.company = contact.company
        contactMO.photo = contact.photo as NSData?
        deletePrevSets(contactMO)
        contactMO.phoneNumbers = getPhoneNumbersFromContact(contact)
        contactMO.emailAddresses = getEmailAddressesFromContact(contact)
    }
    
    private func deletePrevSets(_ contactMO: ContactMO) {
        if let phoneNumbers = contactMO.phoneNumbers?.allObjects as? [PhoneNumberMO] {
            phoneNumbers.forEach({ (phoneNumberMO) in
                let managedContext = actualPersistentContainer.viewContext
                managedContext.delete(phoneNumberMO)
            })
        }
        if let emailAddresses = contactMO.emailAddresses?.allObjects as? [EmailAddressMO] {
            emailAddresses.forEach({ (emailAddressMO) in
                let managedContext = actualPersistentContainer.viewContext
                managedContext.delete(emailAddressMO)
            })
        }
    }
    
    private func getPhoneNumbersFromContact(_ contact: ContactModel) -> NSSet {
        let managedContext = actualPersistentContainer.viewContext
        let filteredContacts = contact.phone.filter { phoneModel in phoneModel.name != nil }
        let phoneNumbers = filteredContacts.map({ (phoneModel) -> PhoneNumberMO in
            let phoneNumberEntity = NSEntityDescription.entity(forEntityName: "Phone", in: managedContext)
            let phoneNumberMO = PhoneNumberMO(entity: phoneNumberEntity!, insertInto: managedContext)
            phoneNumberMO.phoneNumber = phoneModel.name!
            phoneNumberMO.phoneType = phoneModel.phoneType
            return phoneNumberMO
        })
        return NSSet(array: phoneNumbers)
    }
    
    private func getEmailAddressesFromContact(_ contact: ContactModel) -> NSSet {
        let managedContext = actualPersistentContainer.viewContext
        let filteredEmails = contact.email.filter { emailModel in emailModel.email != nil }
        let emailAddresses = filteredEmails.map({ (emailModel) -> EmailAddressMO in
            let emailAddressEntity = NSEntityDescription.entity(forEntityName: "Email", in: managedContext)
            let emailAddressMO = EmailAddressMO(entity: emailAddressEntity!, insertInto: managedContext)
            emailAddressMO.emailAddress = emailModel.email!
            emailAddressMO.emailType = emailModel.emailType
            return emailAddressMO
        })
        return NSSet(array: emailAddresses)
    }
    
    func save() {
        saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy private var persistentContainer: NSPersistentContainer = {
 
        let container = NSPersistentContainer(name: "Contacts")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
    
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    private func saveContext () {
        let context = actualPersistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Testing support
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Contacts", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
}
