//
//  ItemTableViewCell.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    lazy private var itemTypeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("home", for: UIControl.State())
        return button
    }()
    
    lazy private var arrowButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.infoDark)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "rightArrow"), for: UIControl.State())
        button.tintColor = .gray
        button.isEnabled = false
        return button
    }()
    
    lazy private var textfield: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy private var verticalLineView = LineView(color: .gray)
    lazy private var horizontalLineView = LineView(color: .gray)
    
    var viewModel: ItemTableViewCellViewModel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textfield.addTarget(self, action: #selector(textfieldDidChange(textfield:)), for: .editingChanged)
        addSubviews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(itemTypeButton)
        contentView.addSubview(arrowButton)
        contentView.addSubview(verticalLineView)
        contentView.addSubview(horizontalLineView)
        contentView.addSubview(textfield)
    }
    
    private func addConstraints() {
        itemTypeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.layoutMargins.left).isActive = true
        itemTypeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        itemTypeButton.setContentHuggingPriority(.required, for: .horizontal)
        
        arrowButton.leadingAnchor.constraint(equalTo: itemTypeButton.trailingAnchor, constant: 10).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 7/12 * 20).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        verticalLineView.leadingAnchor.constraint(equalTo: arrowButton.trailingAnchor, constant: 10).isActive = true
        verticalLineView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        verticalLineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalLineView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        horizontalLineView.leadingAnchor.constraint(equalTo: itemTypeButton.leadingAnchor).isActive = true
        horizontalLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        horizontalLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        horizontalLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        textfield.leadingAnchor.constraint(equalTo: verticalLineView.leadingAnchor, constant: 10).isActive = true
        textfield.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        textfield.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    internal func configureCell(viewModel: ItemTableViewCellViewModel) {
        self.viewModel = viewModel
        itemTypeButton.setTitle(viewModel.contactInfoTypeName.name, for: UIControl.State())
        textfield.placeholder = viewModel.placeholderText
        textfield.text = viewModel.text
        
        switch viewModel.itemType {
        case .email:
            textfield.keyboardType = .emailAddress
        case .phone:
            textfield.keyboardType = .decimalPad
        }
    }
    
    @objc private func textfieldDidChange(textfield: UITextField) {
        viewModel.textUpdated(textfield.text)
    }

}
