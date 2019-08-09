//
//  PhoneModel.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation

struct PhoneModel {
    
    var name: String?
    var phoneType: String
    
    init(name: String?, phoneType: String) {
        self.name = name
        self.phoneType = phoneType
    }
    
    init(phoneMO: PhoneNumberMO) {
        self.name = phoneMO.phoneNumber
        self.phoneType = phoneMO.phoneType!
    }
    
}

extension PhoneModel: Equatable {
   
    static func ==(lhs: PhoneModel, rhs: PhoneModel) -> Bool {
        return lhs.name == rhs.name && lhs.phoneType == rhs.phoneType
    }
}
