//
//  ContactsTests.swift
//  ContactsTests
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import XCTest
import CoreData
@testable import Contacts

class ContactsTests: XCTestCase {
    
    var databaseManager = DatabaseManager(db: .coreData, isTesting: true)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        NotificationCenter.default.addObserver( self,
                                                selector: #selector(contextSaved(notification:)),
                                                name: NSNotification.Name.NSManagedObjectContextDidSave ,
                                                object: nil )
        initStubs()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        flushData()
        super.tearDown()
    }
    
    func contextSaved( notification: Notification ) {
        print("Context saved: \(notification)")
    }
    
    func initStubs() {
        let phoneNumbers: [PhoneModel] = [ PhoneModel(name: "3332222111", phoneType: "mobile"),
                                         PhoneModel(name: "3332222111", phoneType: "work") ]
        let emailAddresses: [EmailModel] = [ EmailModel(email: "alexanderlookua@gmail.com", emailType: "home"),
                                            EmailModel(email: "alexanderlookua@gmail.com", emailType: "work") ]
        let photo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "profilePlaceholder"), 1)
        insertContact(firstName: "Al",
                      lastName: "Skr",
                      company: "Mobileltd",
                      phoneNumbers: phoneNumbers,
                      emailAddresses: emailAddresses,
                      photo: photo)
        insertContact(firstName: "Al",
                      lastName: "Skr",
                      company: "MobileLTD",
                      phoneNumbers: phoneNumbers,
                      emailAddresses: emailAddresses,
                      photo: photo)
        
        do {
            try databaseManager.actualPersistentContainer.viewContext.save()
        } catch {
            print("Error")
        }
    }
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        let objs = try! databaseManager.actualPersistentContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            databaseManager.actualPersistentContainer.viewContext.delete(obj)
        }
        try! databaseManager.actualPersistentContainer.viewContext.save()
    }
    
    @discardableResult
    private func insertContact(firstName: String?,
                               lastName: String?,
                               company: String?,
                               phoneNumbers: [PhoneModel],
                               emailAddresses: [EmailModel],
                               photo: Data?) -> ContactMO {
        let container = databaseManager.actualPersistentContainer!
        let context = container.viewContext
        let contactEntity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        let contactMO = ContactMO(entity: contactEntity!, insertInto: context)
        let phoneNumbers = phoneNumbers.map { phoneModel in insertNew(phoneNo: phoneModel.name, phoneType: phoneModel.phoneType) }
        let emailAddresses = emailAddresses.map { emailModel in insertNew(emailAddress: emailModel.email, emailType: emailModel.emailType) }
        contactMO.firstName = firstName
        contactMO.lastName = lastName
        contactMO.company = company
        contactMO.phoneNumbers = NSSet(array: phoneNumbers)
        contactMO.emailAddresses = NSSet(array: emailAddresses)
        contactMO.photo = photo as NSData?
        return contactMO
    }
    
    private func insertNew(phoneNo: String?, phoneType: String?) -> PhoneNumberMO {
        let container = databaseManager.actualPersistentContainer!
        let context = container.viewContext
        let phoneNumberEntity = NSEntityDescription.entity(forEntityName: "Phone", in: context)
        let phoneNumberMO = PhoneNumberMO(entity: phoneNumberEntity!, insertInto: context)
        phoneNumberMO.phoneNumber = phoneNo
        phoneNumberMO.phoneType = phoneType
        return phoneNumberMO
    }
    
    private func insertNew(emailAddress: String?, emailType: String?) -> EmailAddressMO {
        let container = databaseManager.actualPersistentContainer!
        let context = container.viewContext
        let emailAddressEntity = NSEntityDescription.entity(forEntityName: "Email", in: context)
        let emailAddressMO = EmailAddressMO(entity: emailAddressEntity!, insertInto: context)
        emailAddressMO.emailAddress = emailAddress
        emailAddressMO.emailType = emailType
        return emailAddressMO
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCreateContact() {
        var contactModel = ContactModel()
        contactModel.firstName = "Al"
        contactModel.lastName = "Skr"
        contactModel.company = "Mobile ltd"
        let phoneNumbers: [PhoneModel] = [ PhoneModel(name: "3332222111", phoneType: "mobile"),
                                           PhoneModel(name: "3332222111", phoneType: "work") ]
        let emailAddresses: [EmailModel] = [ EmailModel(email: "alexanderlookua@gmail.com", emailType: "home"),
                                             EmailModel(email: "alexanderlookua@gmail.com", emailType: "work") ]
        let photo = UIImageJPEGRepresentation(#imageLiteral(resourceName: "profilePlaceholder"), 1)
        contactModel.phone = phoneNumbers
        contactModel.email = emailAddresses
        contactModel.photo = photo
        databaseManager.saveContact(contactModel)
        let contacts = itemsInPersistentStore()
        XCTAssertEqual(contacts.count, 3)
    }
    
    func testFetchAllContacts() {
        let contacts = itemsInPersistentStore()
        let firstContact = contacts.first!
        let lastContact = contacts.last!
        let firstName = firstContact.value(forKey: "firstName")! as! String
        let lastName = lastContact.value(forKey: "firstName")! as! String
        XCTAssertEqual(firstName, "Al")
        XCTAssertEqual(lastName, "Skr")
    }
    
    func testRemoveContact() {
        let contacts = itemsInPersistentStore()
        let firstContact = contacts.first!
        databaseManager.actualPersistentContainer.viewContext.delete(firstContact)
        XCTAssertEqual(numberOfItemsInPersistentStore(), 1)
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Contact")
        let results = try! databaseManager.actualPersistentContainer.viewContext.fetch(request)
        return results.count
    }
    
    func itemsInPersistentStore() -> [NSManagedObject] {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Contact")
        let results = try! databaseManager.actualPersistentContainer.viewContext.fetch(request)
        return results as! [NSManagedObject]
    }
    
}
