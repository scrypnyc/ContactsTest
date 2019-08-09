//
//  NameAndPhotoTableViewCellViewModel.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation

protocol NameAndPhotoCellProtocol: class {
    func firstNameUpdated(_ text: String, position: IndexPath)
    func lastNameUpdated(_ text: String, position: IndexPath)
    func companyUpdated(_ text: String, position: IndexPath)
    func addPhotoAction()
}

class NameAndPhotoTableViewCellViewModel {
    
    let firstNamePlaceholder = "First name"
    let lastNamePlaceholder = "Last name"
    let companyPlaceholder = "Company"
    
    var firstName: String?
    var lastName: String?
    var company: String?
    var photo: Data?
    
    weak var delegate: NameAndPhotoCellProtocol?
    var position: IndexPath
    
    init(indexPath: IndexPath) {
        self.position = indexPath
    }

    internal func firstNameTextUpdated(_ text: String?) {
        firstName = text
        guard let _ = text else { return }
        delegate?.firstNameUpdated(text!, position: position)
    }
    
    internal func lastNameTextUpdated(_ text: String?) {
        lastName = text
        guard let _ = text else { return }
        delegate?.lastNameUpdated(text!, position: position)
    }
    
    internal func companyTextUpdated(_ text: String?) {
        company = text
        guard let _ = text else { return }
        delegate?.companyUpdated(text!, position: position)
    }
    
    internal func addPhotoAction() {
        delegate?.addPhotoAction()
    }
    
}
