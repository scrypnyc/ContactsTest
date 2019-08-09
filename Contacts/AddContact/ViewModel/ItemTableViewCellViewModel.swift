//
//  ItemTableViewCellViewModel.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation

protocol ItemCellProtocol: class {
    func updateItemText(_ text: String, position: IndexPath)
}

class ItemTableViewCellViewModel {
    var itemType: ContactInfoType
    
    var systemNames: [ContactInfoTypeNameProtocol] {
        switch itemType {
        case .email:
            let emailTypes: [EmailTypes] = [.home, .work, .other]
            return emailTypes
        case .phone:
            let phoneTypes: [PhoneTypes] = [.home, .work, .mobile, .other]
            return phoneTypes
        }
    }
    
    var customNames: [ContactInfoTypeNameProtocol]
    var contactInfoTypeName: ContactInfoTypeNameProtocol
    var text: String?
    
    var placeholderText: String {
        switch itemType {
        case .email:
            return "Email"
        case .phone:
            return "Phone"
        }
    }
    
    var position: IndexPath
    
    weak var delegate: ItemCellProtocol?
    
    init(itemType: ContactInfoType, contactInfoTypeName: ContactInfoTypeNameProtocol, customNames: [ContactInfoTypeNameProtocol], indexPath: IndexPath) {
        self.itemType = itemType
        self.contactInfoTypeName = contactInfoTypeName
        self.customNames = customNames
        self.position = indexPath
    }
    
    internal func textUpdated(_ text: String?) {
        self.text = text
        guard let _ = text else { return }
        delegate?.updateItemText(text!, position: position)
    }
    
}
