//
//  EmailAddressMO+CoreDataProperties.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation
import CoreData


extension EmailAddressMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmailAddressMO> {
        return NSFetchRequest<EmailAddressMO>(entityName: "Email")
    }

    @NSManaged public var emailAddress: String?
    @NSManaged public var emailType: String?

}
