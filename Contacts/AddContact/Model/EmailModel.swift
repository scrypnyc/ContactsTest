//
//  EmailModel.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import Foundation

struct EmailModel {
    
    var email: String?
    var emailType: String
    
    init(email: String?, emailType: String) {
        self.email = email
        self.emailType = emailType
    }
    
    init(emailMO: EmailAddressMO) {
        self.email = emailMO.emailAddress
        self.emailType = emailMO.emailType!
    }
    
}

extension EmailModel: Equatable {
    
    static func ==(lhs: EmailModel, rhs: EmailModel) -> Bool {
        return lhs.email == rhs.email && lhs.emailType == rhs.emailType
    }
}
