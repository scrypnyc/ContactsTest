//
//  NameAndPhotoTableViewCell.swift
//  Contacts
//
//  Created by Alexander Skrypnyk on 8/8/19.
//  Copyright © 2019 Alexander Skrypnyk. All rights reserved.
//

import UIKit

class NameAndPhotoTableViewCell: UITableViewCell {
    
    private var firstNameView = LineTextfieldView(placeholder: nil)
    private var lastNameView = LineTextfieldView(placeholder: nil)
    private var companyNameView = LineTextfieldView(placeholder: nil)
    
    lazy private var imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitle("add photo", for: UIControl.State())
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setBackgroundImage(#imageLiteral(resourceName: "profilePlaceholder"), for: UIControl.State())
        return button
    }()
    
    var viewModel: NameAndPhotoTableViewCellViewModel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        firstNameView.delegate = self
        lastNameView.delegate = self
        companyNameView.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        addConstraints()
        imageButton.addTarget(self, action: #selector(addPhotoAction), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageButton.layer.cornerRadius = imageButton.frame.width / 2
        imageButton.layer.borderColor = UIColor.gray.cgColor
        imageButton.layer.borderWidth = 1
    }
    
    private func addSubviews() {
        contentView.addSubview(imageButton)
        contentView.addSubview(firstNameView)
        contentView.addSubview(lastNameView)
        contentView.addSubview(companyNameView)
    }
    
    private func addConstraints() {
        imageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        imageButton.centerYAnchor.constraint(equalTo: firstNameView.centerYAnchor).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        firstNameView.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 30).isActive = true
        firstNameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        firstNameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        lastNameView.topAnchor.constraint(equalTo: firstNameView.bottomAnchor, constant: 20).isActive = true
        lastNameView.leadingAnchor.constraint(equalTo: firstNameView.leadingAnchor).isActive = true
        lastNameView.trailingAnchor.constraint(equalTo: firstNameView.trailingAnchor).isActive = true
        
        companyNameView.topAnchor.constraint(equalTo: lastNameView.bottomAnchor, constant: 20).isActive = true
        companyNameView.leadingAnchor.constraint(equalTo: firstNameView.leadingAnchor).isActive = true
        companyNameView.trailingAnchor.constraint(equalTo: firstNameView.trailingAnchor).isActive = true
        companyNameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    func configureCell(viewModel: NameAndPhotoTableViewCellViewModel) {
        self.viewModel = viewModel
        firstNameView.textfield.placeholder = viewModel.firstNamePlaceholder
        lastNameView.textfield.placeholder = viewModel.lastNamePlaceholder
        companyNameView.textfield.placeholder = viewModel.companyPlaceholder
        firstNameView.textfield.text = viewModel.firstName
        lastNameView.textfield.text = viewModel.lastName
        companyNameView.textfield.text = viewModel.company
        
        if let photo = viewModel.photo, let image = UIImage(data: photo) {
            imageButton.setTitle(nil, for: UIControl.State())
            imageButton.setBackgroundImage(image, for: UIControl.State())
        }
        
    }
    
    @objc private func addPhotoAction() {
        viewModel.addPhotoAction()
    }
    
}

extension NameAndPhotoTableViewCell: LineTextfieldViewProtocol {
    
    func updatedTextfield(_ textfield: UITextField) {
        switch textfield {
        case firstNameView.textfield:
            viewModel.firstNameTextUpdated(textfield.text)
        case lastNameView.textfield:
            viewModel.lastNameTextUpdated(textfield.text)
        case companyNameView.textfield:
            viewModel.companyTextUpdated(textfield.text)
        default:
            break
        }
    }
    
}
