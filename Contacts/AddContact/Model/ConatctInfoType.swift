//
//  ConatctInfoType.swift
//  Contacts
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation

protocol ContactInfoTypeNameProtocol {
    var name: String { get }
}

enum ContactInfoType {
    case phone
    case email
}

enum PhoneTypes: String, ContactInfoTypeNameProtocol {
    case home
    case work
    case mobile
    case other
    
    var name: String {
        return rawValue
    }
    
}

enum EmailTypes: String, ContactInfoTypeNameProtocol {
    case home
    case work
    case other
    
    var name: String {
        return rawValue
    }
}

struct CustomContactInfoTypeName: ContactInfoTypeNameProtocol {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
}
