//
//  LineTextfieldView.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import UIKit

protocol LineTextfieldViewProtocol: class {
    func updatedTextfield(_ textfield: UITextField)
}

class LineTextfieldView: UIView {

    lazy internal var textfield: UITextField = {
        let textfield = UITextField(frame: .zero)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.clearButtonMode = UITextField.ViewMode.whileEditing
        return textfield
    }()
    
    lazy private var lineView: UIView = LineView(color: .gray)
    weak var delegate: LineTextfieldViewProtocol?
    
    init(placeholder: String?, keyboardType: UIKeyboardType = .alphabet) {
        super.init(frame: .zero)
        textfield.placeholder = placeholder
        textfield.keyboardType = keyboardType
        textfield.addTarget(self, action: #selector(textfieldDidChange(textfield:)), for: .editingChanged)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(textfield)
        addSubview(lineView)
    }
    
    private func addConstraints() {
        textfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        textfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        textfield.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
        lineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 10).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @objc private func textfieldDidChange(textfield: UITextField) {
        delegate?.updatedTextfield(textfield)
    }
    
}
