//
//  ApplyPromocodeCell.swift
//  Order
//
//  Created by Арсений on 27.10.2024.
//

import UIKit

final class ApplyPromocodeCell: UITableViewCell {
    var viewModel: TableViewModel.ViewModelType.ApplyPromocode? {
        didSet {
            updateUI()
        }
    }
    
    private lazy var orangeHexColor = {
        let color = UIColor(hex: "#ff4611ff")
        return color
    }()
    
    private lazy var orangeHexColorAlpha = {
        let color = UIColor(hex: "#ff4611ff")?.withAlphaComponent(0.1)
        return color
    }()
    
    private lazy var applyPromocodeButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = orangeHexColorAlpha
        button.setTitleColor(orangeHexColor, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    private lazy var applyPromocodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "percentImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        //imageView.tintColor = orangeHexColor
        return imageView
    }()
    
    private func updateUI() {
        guard let viewModel else {
            return
        }
        
        applyPromocodeButton.setTitle(viewModel.titleApply, for: .normal)
    }

    private func setupUI() {
        contentView.heightAnchor.constraint(equalToConstant: 86).isActive = true
        contentView.addSubview(applyPromocodeButton)
        applyPromocodeButton.translatesAutoresizingMaskIntoConstraints = false
        applyPromocodeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        applyPromocodeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        applyPromocodeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        applyPromocodeButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        applyPromocodeButton.addSubview(applyPromocodeImage)
        applyPromocodeImage.translatesAutoresizingMaskIntoConstraints = false
        applyPromocodeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        applyPromocodeImage.trailingAnchor.constraint(equalTo: applyPromocodeButton.titleLabel?.leadingAnchor ?? applyPromocodeButton.leftAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @objc func tap() {
        print("тап")
    }
}
