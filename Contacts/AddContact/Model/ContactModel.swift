//
//  ContactModel.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation
import UIKit

struct ContactModel {
    
    var firstName: String?
    var lastName: String?
    var company: String?
    var phone: [PhoneModel] = []
    var email: [EmailModel] = []
    var photo: Data?
    
    var fullName: String {
        if let _ = firstName, let _ = lastName {
            return firstName! + " " + lastName!
        } else if let _ = firstName {
            return firstName!
        } else if let _ = lastName {
            return lastName!
        } else if let _ = company {
            return company!
        } else if let phone = phone.first {
            return phone.name!
        } else if let email = email.first {
            return email.email!
        }
        return ""
    }
    
    
    var dbModel: Any?
    
    init() {
        
    }
    
    
    init(contactMO: ContactMO) {
        self.firstName = contactMO.firstName
        self.lastName = contactMO.lastName
        self.company = contactMO.company
        self.photo = contactMO.photo as Data?
        
        if let phoneMOArray = contactMO.phoneNumbers?.allObjects as? [PhoneNumberMO] {
            self.phone = phoneMOArray.map { phoneMO in PhoneModel(phoneMO: phoneMO) }
        }
        
        if let emailMOArray = contactMO.emailAddresses?.allObjects as? [EmailAddressMO] {
            self.email = emailMOArray.map { emailMO in EmailModel(emailMO: emailMO) }
        }
        
        self.dbModel = contactMO
    }
    
    
    func isValidContact() -> Bool {
        let phoneNameNilCount = phone.filter { phoneModel in phoneModel.name == nil }.count
        let emailNameNilCount = email.filter { emailModel in emailModel.email == nil }.count

        if firstName == nil,
            lastName == nil,
            company == nil,
            phone.count == phoneNameNilCount,
            email.count == emailNameNilCount,
            photo == nil {
            return false
        }
        
        return true
    }
    
}


extension ContactModel: Equatable {

    static func ==(lhs: ContactModel, rhs: ContactModel) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.company == rhs.company && lhs.phone == rhs.phone && lhs.email == rhs.email && lhs.photo == rhs.photo
    }

}
