//
//  ContactMO+CoreDataProperties.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//
//

import Foundation
import CoreData


extension ContactMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactMO> {
        return NSFetchRequest<ContactMO>(entityName: "Contact")
    }

    @NSManaged public var company: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var emailAddresses: NSSet?
    @NSManaged public var phoneNumbers: NSSet?

}

// MARK: Generated accessors for emailAddresses
extension ContactMO {

    @objc(addEmailAddressesObject:)
    @NSManaged public func addToEmailAddresses(_ value: EmailAddressMO)

    @objc(removeEmailAddressesObject:)
    @NSManaged public func removeFromEmailAddresses(_ value: EmailAddressMO)

    @objc(addEmailAddresses:)
    @NSManaged public func addToEmailAddresses(_ values: NSSet)

    @objc(removeEmailAddresses:)
    @NSManaged public func removeFromEmailAddresses(_ values: NSSet)

}

// MARK: Generated accessors for phoneNumbers
extension ContactMO {

    @objc(addPhoneNumbersObject:)
    @NSManaged public func addToPhoneNumbers(_ value: PhoneNumberMO)

    @objc(removePhoneNumbersObject:)
    @NSManaged public func removeFromPhoneNumbers(_ value: PhoneNumberMO)

    @objc(addPhoneNumbers:)
    @NSManaged public func addToPhoneNumbers(_ values: NSSet)

    @objc(removePhoneNumbers:)
    @NSManaged public func removeFromPhoneNumbers(_ values: NSSet)

}
