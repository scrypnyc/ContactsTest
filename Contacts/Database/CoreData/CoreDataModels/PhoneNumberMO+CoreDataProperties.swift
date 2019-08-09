//
//  PhoneNumberMO+CoreDataProperties.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//
//

import Foundation
import CoreData


extension PhoneNumberMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneNumberMO> {
        return NSFetchRequest<PhoneNumberMO>(entityName: "Phone")
    }

    @NSManaged public var phoneNumber: String?
    @NSManaged public var phoneType: String?

}
