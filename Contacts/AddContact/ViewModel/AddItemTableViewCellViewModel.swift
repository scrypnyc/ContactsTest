//
//  AddItemTableViewCellViewModel.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation

class AddItemTableViewCellViewModel {
    
    var infoType: ContactInfoType
    
    var placeholder: String {
        switch infoType {
        case .phone:
            return "add phone"
        case .email:
            return "add email"
        }
    }
    
    init(infoType: ContactInfoType) {
        self.infoType = infoType
    }
    
}
